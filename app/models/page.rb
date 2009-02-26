class Page < ActiveRecord::Base
  acts_as_tree :order => :position
  acts_as_list :scope => :parent
  has_many :articles, :order => :position, :dependent => :destroy
  has_many :newsitems, :order => :position, :dependent => :destroy, :include => :images
  has_many :posts, :order => :position, :dependent => :destroy, :include => :images
  has_many :components, :order => :position, :dependent => :destroy
  has_many :events, :order => "datetime, from_date ASC", :dependent => :destroy
  
  validates_presence_of :title, :name

  # unused cache experimentation method
  def self.cached_menu_pages
    if RAILS_ENV == "development"
      self.all_menu_pages
    else
      Rails.cache.fetch('Page.cached_menu_pages') {self.all_menu_pages}
    end
  end
  
  def self.pages_menu(type="primary")
    all_menu_pages.group_by { |p| p[:menu_type] }[type]
  end
  
  def self.all_menu_pages
    find(:all, :conditions => ["parent_id IS NULL"], :include => :children, :order => "position")
  end
  
  def self.all_parents
    find(:all, :select => "parent_id", :conditions => ["parent_id IS NOT NULL"], :group => "parent_id")
  end
  
  def flat_child_links
    # If this is a child page. Return all other children on the same level
    if self.parent_id != nil
      Page.find(:all, :conditions => ["parent_id = ?", self.parent_id], :order => "position")
    # If this is a top level page then return all children
    else
      self.children
    end
  end
  
  def requires_sidebar?
    true if !self.children.size.zero? || !self.parent_id.nil? || !self.components.size.zero?
  end
  
  def to_param
    "#{id}-#{permalink}"
  end
  
  def permalink
    name.downcase.gsub(/[^a-z1-9]+/i, '-') unless name.nil?
  end
  
  def before_destroy
    if self.id == 1
      raise "Can't delete the Home page"
    end
  end
  
  def public?
    true if viewable_by == "public" 
  end
  
  def private?
    true if viewable_by == "all users" 
  end
  
  def all_users?
    true if editable_by == "all users" 
  end
  
  MENUS = [
    [ 'Primary Menu', 'primary' ],
    [ 'Secondary Menu', 'secondary' ]
  ]
  
  KIND = [
    [ 'General  - Text, Images, Video, Table', 'articles' ],
    [ 'News     - News items with dates and archive section', 'newsitems' ],
    [ 'Calendar - Calendar event items', 'events' ],
    [ 'Blog     - Dated articles with comments', 'posts' ]
  ]
  
  PAGINATION = [
    [ 'No Pagination', '' ],
    [ '5 Items per page', 5 ],
    [ '10 Items per page', 10 ],
    [ '20 Items per page', 20 ],
    [ '50 Items per page', 50 ]
  ]
  
  # Unused?
  def self.all_pages_excluding_current(current)
    find(:all, :conditions => ["id != ?", current])
  end
  
  # for the page feed dropdown
  def self.all_pages_for_dropdown(current)
    find(:all, :conditions => ["id != ? AND parent_id IS NULL", current])
  end
  
  def self.pages_for_parent_select(page, action)
    if action != "new"
      conditions = ["id != ? AND menu_type = ? AND parent_id IS NULL", page.id, page.menu_type]
    else
      conditions = ["menu_type = ? AND parent_id IS NULL", page.menu_type]
    end
    defaults = Page.new(:name => "Top Level")
    primary = Page.find(:all, :select => "id, name, parent_id", :conditions => conditions, :order => "position DESC")
    primary << defaults
    primary.reverse
  end
  
  def self.parent_select(page)
    default = Page.new(:name => "Top Level")
    pages = Page.find(:all, :select => "id, name", :conditions => ["parent_id IS NULL AND menu_type =?", page.menu_type], :order => "position")
    pages.insert(0, default)
  end
  
  def name_for_parent_menu
    if parent_id.nil? 
      name 
    else
      "- #{name}"
    end
  end

  # Use the parent_id for the menu list_level class
  def tree_level
    (parent_id != nil) ? parent_id : 0
  end
end
