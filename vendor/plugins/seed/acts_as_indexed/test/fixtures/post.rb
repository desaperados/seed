class Post < ActiveRecord::Base
  acts_as_indexed :fields => [:title, :body], :self_test => true
  
  validates_presence_of :title, :body
end
