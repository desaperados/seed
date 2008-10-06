module FormsHelper
  
  def form_tab_link(name, submittext, resource=nil)
    link_to_function name, :class => selected?(name, resource) do |page| 
    	page.replace_html :tabbedform, :partial => partial_name(name), :locals => {:submit => submittext}
    	page.select('#formtabs li a').each do |a|
    	  a.removeClassName('selected')
    	end
    	page.select("li.#{partial_name(name)}tab a").first.addClassName('selected')
    	page.visual_effect :highlight, :changer, :startcolor => '#bbeeff', :endcolor => '#f8f8f8', :duration => 0.5
    end
  end
  
  private
  
  def selected?(name, resource)
    if !resource.nil?
      "selected" if resource == "selected" || (name.downcase == resource_type(resource))
    end
  end
  
  def partial_name(name)
    name.downcase.gsub(" ", "")
  end
  
  def resource_type(resource)
    resource.article_type if resource.has_attribute? :article_type
    resource.component_type if resource.has_attribute? :component_type
  end
  
end