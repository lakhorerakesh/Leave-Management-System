class User < ActiveRecord::Base
 devise :omniauthable,:database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:facebook]
  has_many :subordinates, :class_name => "User"
  belongs_to :manager, :class_name => "User", :foreign_key => "manager_id"
  belongs_to :role
  has_many :leaves
  has_many :leaves_to_approve, :class_name => "Leave", :foreign_key => "manager_id"
  #validates :email, :name,:password,:manager_id, :role_id, :presence => true
  mount_uploader :image, AvatarUploader
  def is_admin?
    self.role.name.downcase == "admin" if self.role_id
  end

  def is_manager?
    self.role.name.downcase == "manager" if self.role_id
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.token = auth.credentials.token
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.name = data["name"]
        user.image = data.info.image
      end
    end
  end

  # def self.koala(auth)
  #   access_token = auth['token']
  #   facebook = Koala::Facebook::API.new(access_token)
  #   #facebook.get_object("me?fields=name,picture")
  # end
end
