class ApplicationController < ActionController::Base
 protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
  	puts "#{exception.message}"
  	respond_to do |format|
  		flash[:notice] = exception.message
  		format.html { redirect_to root_url }
  	end
  end
end
