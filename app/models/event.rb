class Event < ActiveRecord::Base
  
  belongs_to :page
  validates_presence_of :name
  
  def sortable?
    false
  end
  
  def date_string
    date.to_s(:db)
  end
  
  def date_string=(date_string)
    self.date = DateTime.parse(date_string)
  rescue ArgumentError
    @date_invalid = true
  end
  
  def validate
    errors.add(:date, "is invalid") if @date_invalid
  end
  
end
