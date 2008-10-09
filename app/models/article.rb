class Article < ActiveRecord::Base
  belongs_to :page
  acts_as_list :scope => :page
  has_many :images
  acts_as_indexed :fields => [:title, :content]
  validates_presence_of :title
  
  def sortable?
    true
  end
  
  def to_param
    "#{id}-#{permalink}"
  end
  
  def permalink
    title.downcase.gsub(/[^a-z1-9]+/i, '-')
  end
  
  IMAGESIZE = [
    [ 'Small', 'thumb100' ],
    [ 'Regular', 'thumb200' ],
    [ 'Medium', 'thumb300' ],
    [ 'Large', 'thumb400' ]
  ]
end