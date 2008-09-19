class Newsitem < ActiveRecord::Base
  belongs_to :page
  acts_as_list :scope => :page
  
  validates_presence_of :title
end
