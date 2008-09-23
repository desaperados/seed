class Role < ActiveRecord::Base
  
  has_and_belongs_to_many :users
  validates_presence_of :name
  
  def after_destroy
    if self.name == "admin" && self.users.count.zero?
      raise "Can't delete the last admin user"
    end
  end
  
  def self.pages_for_viewable_by
    default1 = Role.new(:name => "all users")
    default2 = Role.new(:name => "public")
    (roles_for_dropdown << default1 << default2).reverse
  end
  
  def self.pages_for_editable_by
    default = Role.new(:name => "all users")
    (roles_for_dropdown << default).reverse
  end
  
  def capitalised_name
    name.gsub(/^[a-z]|\s+[a-z]/) { |a| a.upcase }
  end
  
  private
  
  def self.roles_for_dropdown
    self.find(:all, :select => "name")
  end
  
end

