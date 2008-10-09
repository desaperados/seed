class SearchController < ApplicationController
  
  before_filter :pages_menu
  
  def index
    if params[:query]
      @results = Article.paginate_search params[:query], :page => params[:page], :per_page => 20
      @grouped_results = @results.group_by { |a| a.article_type }
      @empty = true if @results.empty?
    else
      @empty = true
    end
  end
end