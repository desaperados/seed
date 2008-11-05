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
  
  #TODO - add if_changed? functionality here
  
  # Disabled due to sending emails on login, activation etc
  
  # def after_update(user)
  #  UserMailer.deliver_update_notification(user)
  # end
end
