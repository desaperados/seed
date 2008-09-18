class AddDefaultAdminUser < ActiveRecord::Migration
  def self.up
    # Create admin role
    admin_role = Role.create(:name => 'admin', :description => "Super User with un-restricted access")
    
    # Create default admin user
    user = User.create do |u|
      u.login = 'admin'
      u.name = "Default Admin User"
      u.password = u.password_confirmation = 'monkey'
      u.email = APP_CONFIG[:admin_email]
    end
    
    # Activate user
    # user.register!
    user.activate!
    
    # Add admin role to admin user
    user.roles << admin_role
  end

  def self.down
    Role.delete_all
    User.delete_all
  end
end
