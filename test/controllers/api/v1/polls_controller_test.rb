require 'test_helper'

class PollsControllerTest < ActionController::TestCase

  setup do
    @controller = Api::V1::PollsController.new
    @poll = polls(:one)
  end
  teardown do
    @poll.delete
  end

  test "should create poll" do
    assert_difference('Poll.count') do
      post :create, poll_title: 'create test', answer_titles: ['oh my'], format: :json
    end
    assert_response :success
  end

  test "should show poll" do
    get :show, id: @poll, format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @poll.id.to_s, json['_id']
    assert_equal false, json['finished']
    assert_equal false, json['ip_has_voted']
    assert_equal 0, json['total_votes_count']
  end

  test "should vote on an answer from the poll" do
    answer_no = Answer.new(title: 'no')
    @poll.answers = [Answer.new(title: 'yes'), answer_no]
    put :vote, id: @poll, answer_id: answer_no, format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json['total_votes_count']
    assert_equal true, json['ip_has_voted']
    assert_equal 0, json['answers'][0]['vote_count']
    assert_equal 1, json['answers'][1]['vote_count']
  end

  test "should vote only once" do
    answer_no = Answer.new(title: 'no')
    @poll.answers = [Answer.new(title: 'yes'), answer_no]
    put :vote, id: @poll, answer_id: answer_no, format: :json
    put :vote, id: @poll, answer_id: answer_no, format: :json
    assert_response :unprocessable_entity
  end

  test "should update poll" do
    patch :update, id: @poll, poll: {  }, format: :json
    assert_response :unprocessable_entity
  end

  test "should destroy poll" do
    assert_difference('Poll.count', 0) do
      delete :destroy, id: @poll, format: :json
    end
    assert_response :unprocessable_entity
  end
end
