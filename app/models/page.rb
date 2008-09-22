class Page < ActiveRecord::Base
  acts_as_tree :order => :position
  acts_as_list :scope => :parent
  has_many :articles, :order => :position, :dependent => :destroy
  has_many :newsitems, :order => :position, :dependent => :destroy
  
  validates_presence_of :title, :name
  
  MENUS = [
    [ 'Primary Menu', 'primary' ],
    [ 'Secondary Menu', 'secondary' ]
  ]
  
  KIND = [
    [ 'General - Articles', 'articles' ],
    [ 'News - News items with dates and archive section', 'newsitems' ]
  ]
  
  # TODO - Add some page types
  #[ 'Blog - Dated articles with comments', 'posts' ],
  #[ 'Gallery - Image gallery', 'images' ],
  #[ 'Table - Tabular Information', 'tables' ]
  
  PAGINATION = [
    [ 'No Pagination', '' ],
    [ '5 Items per page', 5 ],
    [ '10 Items per page', 10 ],
    [ '20 Items per page', 20 ],
    [ '50 Items per page', 50 ]
  ]
  
  def pages_for_dropdown(thispage, menu_type, action)
    if action != "new"
      conditions = ["id != ? AND menu_type = ? AND parent_id IS NULL", thispage, menu_type]
    else
      conditions = ["menu_type = ? AND parent_id IS NULL", menu_type]
    end
    list = Page.find(:all, :select => "id, name", :conditions => conditions, :order => "position ASC")
  end

  # Use the parent_id for the menu list_level class
  def tree_level
    (parent_id != nil) ? parent_id : 0
  end
end
