require 'test_helper'

class UsercommentsControllerTest < ActionController::TestCase
  setup do
    @usercomment = usercomments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:usercomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create usercomment" do
    assert_difference('Usercomment.count') do
      post :create, usercomment: { body: @usercomment.body, comment: @usercomment.comment, date: @usercomment.date, repbody: @usercomment.repbody, user_id: @usercomment.user_id }
    end

    assert_redirected_to usercomment_path(assigns(:usercomment))
  end

  test "should show usercomment" do
    get :show, id: @usercomment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @usercomment
    assert_response :success
  end

  test "should update usercomment" do
    put :update, id: @usercomment, usercomment: { body: @usercomment.body, comment: @usercomment.comment, date: @usercomment.date, repbody: @usercomment.repbody, user_id: @usercomment.user_id }
    assert_redirected_to usercomment_path(assigns(:usercomment))
  end

  test "should destroy usercomment" do
    assert_difference('Usercomment.count', -1) do
      delete :destroy, id: @usercomment
    end

    assert_redirected_to usercomments_path
  end
end
