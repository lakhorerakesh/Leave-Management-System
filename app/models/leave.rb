class Leave < ActiveRecord::Base
  require 'calender'
  include LeaveCalender
  belongs_to :user
  has_many :timings, :dependent => :destroy
  accepts_nested_attributes_for :timings
  validates :start_date, :end_date, :reason_for_leave, :user_id, :manager_id, :presence => true

  def leave_array(start_date, end_date)
    actual_start = actual_start_date(start_date)
    actual_end = actual_end_date(end_date)
    l_date_array = []
    no_of_days = (actual_end -actual_start).to_i
    for no_of_day in 0..no_of_days
      l_date_array << actual_start
      actual_start = actual_start + 1
    end
    l_date_array
  end

  def total_days_count
    self.timings.where("start_time IS NOT ? AND end_time IS NOT ?",nil,nil).count
  end

end
