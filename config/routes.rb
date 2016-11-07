LeaveManagementSystem::Application.routes.draw do
  devise_for :users,  :controllers => { :registrations => "users/Registrations",:omniauth_callbacks => "omniauth_callbacks" }
  root :to => "holidays#index"
  resources :holidays
  resources :leaves do
    member do
      get 'approve_leave'

    end
    collection do
      get 'leave_history'
      get 'leave_to_approve'
      get 'list'
    end
  end
  devise_scope :user do
    get 'fetch_user_friends', :to => 'omniauth_callbacks#fetch_user_friends', :as => :fetch_user_friends
  end
end
