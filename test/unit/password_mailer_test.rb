require 'test_helper'

class PasswordMailerTest < ActionMailer::TestCase
  tests PasswordMailer
  def test_forgot_password
    @expected.subject = 'PasswordMailer#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, PasswordMailer.create_forgot_password(@expected.date).encoded
  end

  def test_reset_password
    @expected.subject = 'PasswordMailer#reset_password'
    @expected.body    = read_fixture('reset_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, PasswordMailer.create_reset_password(@expected.date).encoded
  end

end
