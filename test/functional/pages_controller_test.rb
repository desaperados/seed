require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def setup
    @valid = {:title => 'Page', :name => 'Page'}
  end

  def test_as_admin_getting_index_should_succeed
    login_as :admin
    get :index
    assert_response :success
    
    assert_not_nil assigns(:viewable)
    assert assigns(:viewable).is_a?(Array)
    
    assert_not_nil assigns(:editable)
    assert assigns(:editable).is_a?(Array)
    
    assert_not_nil assigns(:parents)
    assert assigns(:parents).is_a?(Array)
    assert_equal ['parent_0', 'parent_00'], assigns(:parents)[0,2]
  end
  
  def test_as_member_getting_index_should_not_be_authorized
    login_as :quentin
    get :index
    assert_response 401
  end
  
  def test_as_visitor_getting_index_should_be_redirected_to_login
    get :index
    assert_redirected_to new_session_path
  end

  def test_as_admin_getting_new_should_succeed
    login_as :admin
    get :new
    assert_response :success
  end
  
  def test_as_member_getting_new_should_not_be_authorized
    login_as :quentin
    get :new
    assert_response 401
  end
  
  def test_as_visitor_getting_new_should_be_redirected_to_login
    get :new
    assert_redirected_to new_session_path
  end

  def test_as_admin_creating_page_should_succeed
    login_as :admin
    assert_difference('Page.count') do
      post :create, :page => @valid
    end

    assert_redirected_to resources_path(assigns(:page))
  end
  
  def test_as_member_creating_page_should_not_be_authorized
    login_as :quentin
    post :create, :page => @valid
    assert_response 401
  end

  def test_as_visitor_creating_page_should_be_redirected_to_login
    post :create, :page => @valid
    assert_redirected_to new_session_path
  end
  
  def test_as_admin_showing_page_should_succeed
    login_as :admin
    get :show, :id => pages(:one).id
    assert_redirected_to resources_path(pages(:one))
  end

  def test_as_user_showing_page_should_succeed
    login_as :quentin
    get :show, :id => pages(:one).id
    assert_redirected_to resources_path(pages(:one))
  end

  def test_as_visitor_showing_page_should_succeed
    get :show, :id => pages(:one).id
    assert_redirected_to resources_path(pages(:one))
  end

  def test_as_admin_getting_edit_should_succeed
    login_as :admin
    get :edit, :id => pages(:one).id
    assert_response :success
  end

  def test_as_member_getting_edit_should_not_be_authorized
    login_as :quentin
    get :edit, :id => 1
    assert_response 401
  end
  
  def test_as_visitor_getting_edit_should_be_redirected_to_login
    get :edit, :id => 1
    assert_redirected_to new_session_path
  end

  def test_as_admin_updating_page_should_succeed
    login_as :admin
    put :update, :id => pages(:one).id, :page => { }
    assert_redirected_to resources_path(assigns(:page))
  end
  
  def test_as_user_updating_page_should_not_be_authorized
    login_as :quentin
    put :update, :id => pages(:one).id, :page => { }
    assert_response 401
  end
  
  def test_as_visitor_updating_page_should_redirect_to_login
    put :update, :id => pages(:one).id, :page => { }
    assert_redirected_to new_session_path
  end

  def test_as_admin_destroying_page_should_succeed
    login_as :admin
    assert_difference('Page.count', -1) do
      delete :destroy, :id => pages(:two).id
    end

    assert_redirected_to resources_path(pages(:one))
  end

  def test_as_member_destroying_page_should_not_be_authorized
    login_as :quentin
    delete :destroy, :id => 1
    assert_response 401
  end

  def test_as_admin_destroying_page_should_succeed
    delete :destroy, :id => 1
    assert_redirected_to new_session_path
  end

  protected
  
  def resources_path(page)
    eval ("#{page.kind}_path(#{page.id})") 
  end

end
