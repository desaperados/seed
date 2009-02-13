class Newsitem < Article
  
  def self.find(*args)
    with_scope(:find=> { :conditions=> "article_type = 'news'" } ) do
      super(*args)
    end
  end
  
  def sortable?
    false
  end
  
end
