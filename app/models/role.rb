class Role < ActiveRecord::Base
  
  has_and_belongs_to_many :users
  validates_presence_of :name
  
  def after_destroy
    if self.name == "admin" && self.users.count.zero?
      raise "Can't delete the last admin user"
    end
  end
  
end