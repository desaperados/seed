require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def test_as_admin_getting_index_should_succeed
    login_as :admin
    get :index, :page_id => 1
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  def test_as_member_getting_index_should_succeed
    login_as :quentin
    get :index, :page_id => 1
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  def test_as_visitor_getting_index_should_succeed
    get :index, :page_id => 1
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  def test_as_admin_getting_new_should_succeed
    login_as :admin
    get :new, :page_id => 1
    assert_response :success
  end

  def test_as_member_getting_new_should_succeed
    login_as :quentin
    get :new, :page_id => 1
    assert_response :success
  end

  def test_as_visitor_getting_new_should_be_redirected_to_login
    get :new, :page_id => 1
    assert_redirected_to new_session_path
  end

  def test_as_admin_creating_article_should_succeed
    login_as :admin
    assert_difference('Article.count') do
      post :create, :article => {:title => 'test'}, :page_id => 1
    end

    assert_redirected_to resource_index_page(assigns(:article))
  end

  def test_as_member_creating_article_should_succeed
    login_as :quentin
    assert_difference('Article.count') do
      post :create, :article => {:title => 'test'}, :page_id => 1
    end

    assert_redirected_to resource_index_page(assigns(:article))
  end

  def test_as_visitor_creating_article_should_be_redirected_to_login
    post :create, :article => {:title => 'test'}, :page_id => 1
    assert_redirected_to new_session_path
  end

  def test_as_admin_getting_edit_should_succeed
    login_as :admin
    get :edit, :id => articles(:one).id, :page_id => 1
    assert_response :success
  end

  def test_as_member_getting_edit_should_succeed
    login_as :quentin
    get :edit, :id => articles(:one).id, :page_id => 1
    assert_response :success
  end

  def test_as_visitor_getting_edit_should_be_redirected_to_login
    get :edit, :id => articles(:one).id, :page_id => 1
    assert_redirected_to new_session_path
  end

  def test_as_admin_updating_article_should_succeed
    login_as :admin
    put :update, :id => articles(:one).id, :article => { }
    assert_redirected_to resource_index_page(assigns(:article))
  end

  def test_as_member_updating_article_should_succeed
    login_as :quentin
    put :update, :id => articles(:one).id, :article => { }
    assert_redirected_to resource_index_page(assigns(:article))
  end

  def test_as_visitor_updating_article_should_be_redirected_to_login
    put :update, :id => 1, :article => { }
    assert_redirected_to new_session_path
  end

  def test_as_admin_destroying_article_should_succeed
    login_as :admin
    assert_difference('Article.count', -1) do
      delete :destroy, :id => articles(:one).id
    end

    assert_redirected_to resource_index_page(assigns(:article))
  end
  
  def test_as_member_destroying_article_should_succeed
    login_as :quentin
    assert_difference('Article.count', -1) do
      delete :destroy, :id => articles(:one).id
    end

    assert_redirected_to resource_index_page(assigns(:article))
  end
  
  def test_as_visitor_destroying_article_should_be_redirected_to_login
    delete :destroy, :id => 1
    assert_redirected_to new_session_path
  end
  
  protected

  def resource_index_page(resource)
    if resource.article_type == "post"
      posts_path(resource.page_id) 
    elsif resource.article_type == "news"
      newsitems_path(resource.page_id) 
    else
      articles_path(resource.page_id) 
    end
  end

end
