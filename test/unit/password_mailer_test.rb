require 'test_helper'

class PasswordMailerTest < ActionMailer::TestCase
  tests PasswordMailer
  
  def test_forgot_password
    user = users(:quentin)
    password = Password.new(:reset_code => 'abc', :user => user)
    mailer = PasswordMailer.create_forgot_password(password)
    
    assert_equal "[#{APP_CONFIG[:site_name]}] You have requested to change your password", mailer.subject
    assert mailer.from.include?(APP_CONFIG[:admin_email])
    assert mailer.to.include?('quentin@example.com')
    assert mailer.body =~ /#{APP_CONFIG[:site_url]}\/change_password\/abc/
  end

  def test_reset_password
    user = users(:quentin)
    mailer = PasswordMailer.create_reset_password(user)

    assert_equal "[#{APP_CONFIG[:site_name]}] Your password has been reset.", mailer.subject
    assert mailer.from.include?(APP_CONFIG[:admin_email])
    assert mailer.to.include?('quentin@example.com')
  end

end
