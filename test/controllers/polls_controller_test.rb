require 'test_helper'

class Api::V1::PollsControllerTest < ActionController::TestCase
  setup do
    @poll = polls(:one)
  end
  teardown do
    @poll.delete
  end

  test "should show poll" do
    get :show, id: @poll, format: :html
    assert_response :success
  end
end
