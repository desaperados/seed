class Newsitem < Article
  
  def self.find(*args)
    with_scope(:find=> { :conditions=> "article_type = 'news'" } ) do
      super(*args)
    end
  end
  
  def sortable?
    false
  end
  
  def self.find_all_in_month(year, month, page, per_page)
    conditions = ["created_at BETWEEN ? AND ?", DateTime.new(year, month, 1), DateTime.new(year, month, days_in_month(year, month), 11, 59, 59)]
    self.paginate(:page => page, :per_page => per_page, :conditions => conditions, :order => "created_at DESC")
  end
  
  def self.find_all_in_year(year, page, per_page)
    conditions =  ["created_at BETWEEN ? AND ?", DateTime.new(year, 1, 1), DateTime.new(year, 12, 31, 11, 59, 59)]
    self.paginate(:page => page, :per_page => per_page, :conditions => conditions, :order => "created_at DESC")
  end
  
  private

  def self.days_in_month(year, month)
    Date.new(year, month, -1).day
  end
  
end
