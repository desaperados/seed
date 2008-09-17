require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:images)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_image
    assert_difference('Image.count') do
      post :create, :image => { }
    end

    assert_redirected_to image_path(assigns(:image))
  end

  def test_should_show_image
    get :show, :id => images(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => images(:one).id
    assert_response :success
  end

  def test_should_update_image
    put :update, :id => images(:one).id, :image => { }
    assert_redirected_to image_path(assigns(:image))
  end

  def test_should_destroy_image
    assert_difference('Image.count', -1) do
      delete :destroy, :id => images(:one).id
    end

    assert_redirected_to images_path
  end
end
