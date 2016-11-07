class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    omniauth = request.env["omniauth.auth"]
    @graph = Koala::Facebook::API.new(omniauth.credentials.token)
    @user = User.from_omniauth(omniauth)
    if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
  end

  def failure
    redirect_to root_path
  end

  def fetch_user_friends
    binding.pry
   @graph = Koala::Facebook::API.new(current_user.token)
   @facebook_friends = @graph.get_connections("me", "friends?fields=id,name,picture")
  end

  def fetch_user_profile
   @graph = Koala::Facebook::API.new(current_user.token)
   @facebook_profiles = @graph.get_object("me") 
  end
end