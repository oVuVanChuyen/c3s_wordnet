require "test_helper"

class WordNetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @word_net = word_nets(:one)
  end

  test "should get index" do
    get word_nets_url
    assert_response :success
  end

  test "should get new" do
    get new_word_net_url
    assert_response :success
  end

  test "should create word_net" do
    assert_difference('WordNet.count') do
      post word_nets_url, params: { word_net: { keyword: @word_net.keyword } }
    end

    assert_redirected_to word_net_url(WordNet.last)
  end

  test "should show word_net" do
    get word_net_url(@word_net)
    assert_response :success
  end

  test "should get edit" do
    get edit_word_net_url(@word_net)
    assert_response :success
  end

  test "should update word_net" do
    patch word_net_url(@word_net), params: { word_net: { keyword: @word_net.keyword } }
    assert_redirected_to word_net_url(@word_net)
  end

  test "should destroy word_net" do
    assert_difference('WordNet.count', -1) do
      delete word_net_url(@word_net)
    end

    assert_redirected_to word_nets_url
  end
end
