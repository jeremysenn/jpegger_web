require 'test_helper'

class SuspectListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @suspect_list = suspect_lists(:one)
  end

  test "should get index" do
    get suspect_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_suspect_list_url
    assert_response :success
  end

  test "should create suspect_list" do
    assert_difference('SuspectList.count') do
      post suspect_lists_url, params: { suspect_list: { company_id: @suspect_list.company_id, delimiter: @suspect_list.delimiter, file: @suspect_list.file, name: @suspect_list.name, user_id: @suspect_list.user_id } }
    end

    assert_redirected_to suspect_list_url(SuspectList.last)
  end

  test "should show suspect_list" do
    get suspect_list_url(@suspect_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_suspect_list_url(@suspect_list)
    assert_response :success
  end

  test "should update suspect_list" do
    patch suspect_list_url(@suspect_list), params: { suspect_list: { company_id: @suspect_list.company_id, delimiter: @suspect_list.delimiter, file: @suspect_list.file, name: @suspect_list.name, user_id: @suspect_list.user_id } }
    assert_redirected_to suspect_list_url(@suspect_list)
  end

  test "should destroy suspect_list" do
    assert_difference('SuspectList.count', -1) do
      delete suspect_list_url(@suspect_list)
    end

    assert_redirected_to suspect_lists_url
  end
end
