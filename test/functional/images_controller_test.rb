require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def setup
    @valid = {:size => 1, :content_type => 'image/jpeg', :filename => 'test.jpg'}
  end
  
  def test_as_admin_getting_new_should_succeed
    login_as(:admin)
    get :new
    assert_response :success
  end

  def test_as_member_getting_new_should_succeed
    login_as(:quentin)
    get :new
    assert_response :success
  end

  def test_as_visitor_getting_new_should_be_redirected_to_login
    get :new
    assert_redirected_to new_session_path
  end

  def test_as_admin_creating_images_should_succeed
    login_as :admin
    
    assert_difference('Image.count') do
      post :create, :image => @valid
    end

    assert_response :success
  end

  def test_as_member_creating_images_should_succeed
    login_as :quentin
    
    assert_difference('Image.count') do
      post :create, :image => @valid
    end

    assert_response :success
  end

  def test_as_visitor_creating_images_should_be_redirected_to_login
    post :create, :image => {}
    assert_redirected_to new_session_path
  end

  def test_as_admin_destroying_image_should_succeed
    login_as :admin
    
    assert_difference('Image.count', -1) do
      delete :destroy, :id => images(:one).id
    end

    assert_redirected_to new_image_path
  end

  def test_as_member_destroying_image_should_succeed
    login_as :quentin
    
    assert_difference('Image.count', -1) do
      delete :destroy, :id => images(:one).id
    end

    assert_redirected_to new_image_path
  end

  def test_as_visitor_destroying_image_should_be_redirected_to_login
    delete :destroy, :id => 1
    assert_redirected_to new_session_path
  end
end
