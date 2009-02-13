class Article < ActiveRecord::Base
  belongs_to :page
  acts_as_list :scope => :page
  has_many :images
  has_many :documents
  acts_as_indexed :fields => [:title, :content]
  validates_presence_of :title
  
  # Strip any speech marks and replace with a marker
  def before_save
    self.content = content.gsub(/["]/, '[s-mark]') unless content.nil?
  end
  
  def sortable?
    true
  end
  
  def parsed_video
    @parsed_video ||= video.gsub('watch?v=','v/')
  end
  
  def to_param
    "#{id}-#{permalink}" unless id.nil?
  end
  
  def permalink
    title.downcase.gsub(/[^a-z1-9]+/i, '-') unless title.nil?
  end
  
  def component_preview
    content.slice(0, 100) + "..."
  end
  
  IMAGESIZE = [
    [ 'Small', 'thumb100' ],
    [ 'Regular', 'thumb200' ],
    [ 'Medium', 'thumb300' ],
    [ 'Large', 'thumb400' ]
  ]
  
  # For the news and blog archive sections
  def self.find_all_in_month(year, month, page_params, page)
    conditions = ["page_id = ? AND created_at BETWEEN ? AND ?", page.id, DateTime.new(year, month, 1), DateTime.new(year, month, days_in_month(year, month), 11, 59, 59)]
    self.paginate(:page => page_params, :per_page => page.paginate, :include => :images, :conditions => conditions, :order => "created_at DESC")
  end
  
  def self.find_all_in_year(year, page_params, page)
    conditions =  ["page_id = ? AND created_at BETWEEN ? AND ?", page.id, DateTime.new(year, 1, 1), DateTime.new(year, 12, 31, 11, 59, 59)]
    self.paginate(:page => page_params, :per_page => page.paginate, :include => :images, :conditions => conditions, :order => "created_at DESC")
  end
  
  def self.archive_links(page)
    self.find(:all, :select => "created_at", :conditions => ["page_id = ?", page.id]).group_by {|a| a.created_at.strftime('%Y')}.sort.reverse
  end
  
  private

  def self.days_in_month(year, month)
    Date.new(year, month, -1).day
  end
  
end