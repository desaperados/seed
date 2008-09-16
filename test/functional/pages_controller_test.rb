require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_page
    assert_difference('Page.count') do
      post :create, :page => { }
    end

    assert_redirected_to page_path(assigns(:page))
  end

  def test_should_show_page
    get :show, :id => pages(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pages(:one).id
    assert_response :success
  end

  def test_should_update_page
    put :update, :id => pages(:one).id, :page => { }
    assert_redirected_to page_path(assigns(:page))
  end

  def test_should_destroy_page
    assert_difference('Page.count', -1) do
      delete :destroy, :id => pages(:one).id
    end

    assert_redirected_to pages_path
  end
end
