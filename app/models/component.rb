class Component < ActiveRecord::Base
  belongs_to :page, :counter_cache => true
  belongs_to :source, :class_name => "Page", :foreign_key => :source_page
  acts_as_list :scope => :page_id
  has_many :documents
  validates_presence_of :title
  
  def snippets
    snippet_class.constantize.find(:all, :order => order, :limit => limit, :conditions => ["page_id = ?", source_page])
  end
  
  def page_feed?
    true if component_type == "pagefeed"
  end
  
  def documents?
    true if component_type == "documents"
  end
  
  def text?
    true if component_type == "text"
  end
  
  ORDER_OPTIONS = [
    [ 'Created Descending', 'created_at DESC' ],
    [ 'Created Ascending', 'created_at ASC' ],
    [ 'Title Descending', 'title DESC' ],
    [ 'Title Ascending', 'title ASC' ]
  ]
  
  LIMIT_OPTIONS = [
    [ '1 Item', 1 ],
    [ '3 Items', 3 ],
    [ '5 Items', 5 ],
    [ '10 Items', 10 ]
  ]
end
