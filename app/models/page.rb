class Page < ActiveRecord::Base
  acts_as_tree :order => :position
  acts_as_list :scope => :parent
  has_many :articles, :order => :position
  has_many :childeren, :class_name => Page, :foreign_key => :parent_id, :order => :position
  
  def self.pages_for_dropdown(excluded="NULL")
    list = find(:all, :select => "id, name", :conditions => ["id != ?", excluded])
  end

  # Use the parent_id for the menu list_level class
  def tree_level
    (parent_id != nil) ? parent_id : 0
  end
end
