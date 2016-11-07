class LeavesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def leave_history
    @leaves = Leave.where("user_id =? AND end_date < ? ", current_user.id, Date.today )
  end
  
  def index
    @leaves = Leave.where("user_id =? AND end_date >= ? ", current_user.id, Date.today )
  end
  
  def list
    start_date = params[:start_date].to_date
    end_date = params[:end_date].to_date
    @total_days = total_days_applied(start_date, end_date)
    @holiday_day = Holiday.new.holiday_between_leaves(start_date, end_date)
    @working_days = @total_days.reject{ |d| @holiday_day.include?(d)}
  end
  
  def new
    @leave = Leave.new
    @leave.timings.build
  end

  def create
    start_date = params[:leave][:start_date].to_date
    end_date = params[:leave][:end_date].to_date
    @timings = params[:leave][:timings_attributes]
    timings_attributes_array = []
    @timings.each do |key, value|
      temp = {}
      temp[:start_time] = value[:start_time] rescue nil
      temp[:end_time] = value[:end_time] rescue nil
      temp[:id] = value[:id] rescue nil
      temp[:leave_date] =  key rescue nil
      temp[:my_boolean] = value[:my_boolean] rescue nil
      timings_attributes_array << temp 
    end
    @leave = Leave.new(start_date: start_date,end_date: end_date,reason_for_leave:params[:leave][:reason_for_leave],timings_attributes: timings_attributes_array)
    @total_days = total_days_applied(start_date, end_date)
    @holiday_day = Holiday.new.holiday_between_leaves(start_date, end_date)
    @working_day = @total_days.reject{ |d| @holiday_day.include?(d)}
    @leave.user_id = current_user.id
    @leave.manager_id = current_user.manager
    @leave.status = "pending"
    @leave.working_days = @working_day.count
    @leave.holiday_days = @holiday_day.count
    @leave.total_days = @total_days.size
    if @leave.valid?
      @leave.save
      LmsMailer.applied_for_leave(@leave, current_user, @working_day, @holiday_day).deliver
      redirect_to leaves_path
    else
      render 'new'
    end
  end

  def total_days_applied(start_date, end_date)
    Leave.new.leave_array(start_date, end_date)
  end

  def show
    @leave = Leave.find(params[:id])
    @total_days = @leave.total_days.to_i - @leave.holiday_days.to_i
    @half_days  = @leave.timings.where("start_time IS NOT ? AND end_time IS NOT ?",nil,nil)
    @total_full_days = @total_days - @half_days.count
  end

  def edit
    @leave = Leave.find(params[:id])
    @timings = @leave.timings
    start_date = @leave.start_date
    end_date = @leave.end_date
    @total_days = total_days_applied(start_date, end_date)
    @holiday_day = Holiday.new.holiday_between_leaves(start_date, end_date)
    @working_days = @total_days.reject{ |d| @holiday_day.include?(d)}
  end

  def update
    @leave = Leave.find(params[:id])
    changed_start_date = @leave.start_date != params[:leave][:start_date].to_date
    changed_end_date = @leave.end_date != params[:leave][:end_date].to_date
    if changed_start_date || changed_end_date
      @leave.timings.destroy_all
      @leave.start_date = params[:leave][:start_date].to_date
      @leave.end_date = params[:leave][:end_date].to_date 
    else
      @leave.start_date = @leave.start_date
      @leave.end_date = @leave.end_date
    end  
    @leave.manager_id = current_user.manager
    @leave.reason_for_leave = params[:leave][:reason_for_leave]
    @total_days = total_days_applied(@leave.start_date, @leave.end_date)
    @holiday_day = Holiday.new.holiday_between_leaves(@leave.start_date, @leave.end_date)
    @working_day = @total_days.reject{ |d| @holiday_day.include?(d)}
    @leave.working_days = @working_day.count
    @leave.holiday_days = @holiday_day.count
    @leave.total_days = @total_days.size
    @leave.user_id = current_user.id

    @timings = params[:leave][:timings_attributes]
    timings_attributes_array = []
    @timings.each do |key, value|
      temp = {}
      temp[:start_time] = value[:start_time] rescue nil
      temp[:end_time] = value[:end_time] rescue nil
      temp[:id] = value[:id] rescue nil
      temp[:leave_date] =  key rescue nil
      temp[:my_boolean] = value[:my_boolean] rescue nil
      timings_attributes_array << temp 
    end
    @leave.update_attributes(timings_attributes: timings_attributes_array)

    if @leave.valid?
      @leave.save
      LmsMailer.applied_for_leave(@leave, current_user, @working_day, @holiday_day).deliver
      redirect_to leaves_path
    else
      render 'edit'
    end
  end

  def destroy
    @leave = Leave.find(params[:id])
    @leave.delete
    redirect_to leaves_path
  end

  def leave_to_approve
    @leaves = Leave.where(:manager_id => current_user.id, :status => "pending")
  end

  def approve_leave
    authorize! :update ,current_user.is_admin? || current_user.is_manager?
    leave = Leave.find(params[:id])
    status = params[:rejected].present? ? params[:rejected] : "Approved"
    if leave.update_attribute("status",status)
      LmsMailer.leave_approved(leave,current_user, status).deliver
      redirect_to leave_to_approve_leaves_path
    end
  end
end
