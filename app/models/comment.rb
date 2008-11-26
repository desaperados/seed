class Comment < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :name, :email, :comment
  before_create :check_for_spam
  
  named_scope :approved, :conditions => ["approved = ?", true]
  named_scope :unapproved, :conditions => ["approved = ?", false]
  
  def self.recent(limit, conditions=nil)
    find(:all, :limit => limit, :conditions => conditions, :order => 'created_at DESC')
  end
  
  def request=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = request.env['HTTP_REFERER']
  end
  
  def check_for_spam
    self.approved = !Akismetor.spam?(akismet_attributes)
    true # return true so it doesn't stop save
  end
  
  def mark_as_spam!
    update_attribute(:approved, false)
    Akismetor.submit_spam(akismet_attributes)
  end

  def mark_as_ham!
    update_attribute(:approved, true)
    Akismetor.submit_ham(akismet_attributes)
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
