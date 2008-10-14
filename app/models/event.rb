class Event < ActiveRecord::Base
  
  belongs_to :page
  validates_presence_of :name, :date
  
  def self.future_events(year, month)
    from = Date.new(year, month)
    find(:all, :conditions => ['datetime >= ? OR from_date >= ?', from, from ], :order => "datetime, from_date ASC")
  end
  
  def sortable?
    false
  end
  
  def date
    (all_day?) ? from_date : datetime
  end
  
  def to_param
    "#{id}-#{permalink}" unless id.nil?
  end
  
  def permalink
    name.downcase.gsub(/[^a-z1-9]+/i, '-') unless name.nil?
  end
  
  def title
    name
  end
  
  def calendar_date
    (all_day?) ? from_date : Date.parse(datetime.to_s)
  end
  
  def duration
    if (all_day? && from_date == to_date) || (!all_day)
      duration = 1
    else
      duration = (to_date - from_date).to_i
    end
  end
  
  def range
    if duration == 1
      return calendar_date
    else
      date_iterator = from_date - 1.day
      dates = []
      while date_iterator < to_date
        date_iterator += 1.day
        dates << date_iterator
      end
      dates
    end
  end
  
end
