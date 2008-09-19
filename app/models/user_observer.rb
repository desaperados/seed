class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_activated?
  end
  
  def after_destroy(user)
    UserMailer.deliver_termination_notification(user)
  end
end
