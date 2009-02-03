class SearchController < ApplicationController
  
  def index
    if params[:query]
      @results = Article.paginate_search params[:query], :page => params[:page], :per_page => 20
      @results.delete_if { |result| private?(result.page)}
      @grouped_results = @results.group_by { |a| a.article_type } 
      @empty = true if @results.empty?
    else
      @empty = true
    end
  end
  
  private 
  
  def private?(page)
    # Public Searches
    if !logged_in? && !page.public?
      return true
    elsif logged_in? && !current_user.has_role?("#{page.viewable_by}")
      return true
    end
  end
  
end