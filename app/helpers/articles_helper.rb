module ArticlesHelper
  
  def articles_menu_link(name, submittext, article=nil)
    link_to_function name, :class => selected?(name, article) do |page| 
    	page.replace_html :articlesform, :partial => name.downcase, :locals => {:submit => submittext}
    	page.select('#articletabs li a').each do |a|
    	  a.removeClassName('selected')
    	end
    	page.select("li.#{name.downcase}tab a").first.addClassName('selected')
    	page.visual_effect :highlight, :changer, :startcolor => '#bbeeff', :endcolor => '#f8f8f8', :duration => 0.5
    end
  end
  
  private
  
  def selected?(name, article)
    article if article == "selected"
    if !article.nil?
      "selected" if article == "selected" || (name.downcase == article.content_type) && article != nil
    end
  end
  
end