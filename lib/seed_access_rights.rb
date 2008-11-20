module SeedAccessRights
  protected
  
  def check_access
    check_view_rights
    check_edit_rights
  end
  
  def check_view_rights
    if logged_in? 
      if !viewable?
        redirect_to root_url
      end
    elsif @page.viewable_by != "public"
      redirect_to root_url
    end
  end
  
  def check_edit_rights
    if logged_in? 
      if !viewable?
        redirect_to root_url
      end
    else 
      redirect_to root_url
    end
  end
  
  def viewable?
    current_user.has_role?("#{@page.viewable_by}") || @page.viewable_by != "all users"
  end
  
  def editable?
    current_user.has_role?("#{@page.editable_by}") || @page.editable_by != "all users"
  end
end