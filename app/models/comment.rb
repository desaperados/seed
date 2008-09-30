class Comment < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :name, :email, :comment
  before_create :check_for_spam
  
  def request=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = request.env['HTTP_REFERER']
  end
  
  def check_for_spam
    self.approved = !Akismetor.spam?(akismet_attributes)
    true # return true so it doesn't stop save
  end
  
  def akismet_attributes
    {
      :key                    => APP_CONFIG[:akismet_key],
      :blog                   => APP_CONFIG[:site_url],
      :user_ip                => user_ip,
      :user_agent             => user_agent,
      :comment_author         => name,
      :comment_author_email   => email,
      :comment_author_url     => website,
      :comment_content        => comment
    }
  
  end
end
