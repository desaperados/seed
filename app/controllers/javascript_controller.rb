class JavascriptController < ApplicationController
  
  def update_article_order
    params[:articles].each_with_index do |id, position|
      Article.update(id, :position => position)
    end
    render(:nothing => true)
  end
  
  def update_page_order
    params[:menupages].each_pair do |position, value|
      if value.is_a?(Hash)
        value.each_pair do |pos, v|
          if v.is_a?(String)
            Page.update(v, :position => position)
          else
            Page.update(v.values[0], :position => pos)
          end
        end
      else
        Page.update(value.values, :position => position)
      end
    end
    render(:nothing => true)
  end
  
end

