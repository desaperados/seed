class Article < ActiveRecord::Base
  belongs_to :page
  acts_as_list :scope => :page
  has_many :images
  
  validates_presence_of :title
  
  def sortable?
    true
  end
  
  IMAGESIZE = [
    [ 'Small', 'thumb100' ],
    [ 'Regular', 'thumb200' ],
    [ 'Medium', 'thumb300' ],
    [ 'Large', 'thumb400' ]
  ]
end