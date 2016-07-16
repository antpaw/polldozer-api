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
    assert_equal Time.now.utc.to_date, Time.at(json['created_at']).utc.to_date
    assert_equal 0, json['total_votes_count']
  end

  test "poll should not show users_vote and winner" do
    @poll.answers = [Answer.new(title: 'yes'), Answer.new(title: 'no')]
    get :show, id: @poll, format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal nil, json['answers'][0]['users_vote']
    assert_equal nil, json['answers'][1]['users_vote']
    assert_equal nil, json['answers'][0]['winner']
    assert_equal nil, json['answers'][1]['winner']
  end

  test "poll should show users_vote and winner as false" do
    @poll = polls(:finished)
    @poll.answers = [Answer.new(title: 'yes'), Answer.new(title: 'no')]
    get :show, id: @poll, format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal false, json['answers'][0]['winner']
    assert_equal false, json['answers'][1]['winner']
    assert_equal nil, json['answers'][0]['users_vote']
    assert_equal nil, json['answers'][1]['users_vote']
  end

  test "poll should show users_vote 'true' with :vote_id" do
    answer_no = Answer.new(title: 'no')
    @poll.answers = [Answer.new(title: 'yes'), answer_no]
    put :vote, id: @poll, answer_id: answer_no, format: :json
    vote_id = JSON.parse(response.body)['vote_id']
    get :show, id: @poll, vote_id: vote_id, format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal false, json['answers'][0]['users_vote']
    assert_equal true, json['answers'][1]['users_vote']
  end

  # `users_answer_id` performance optimization
  # test "poll should show users_vote 'true' with :users_answer_id" do
  #   answer_yes = Answer.new(title: 'yes')
  #   answer_no = Answer.new(title: 'no')
  #   @poll.answers = [answer_yes, answer_no]
  #   put :vote, id: @poll, answer_id: answer_yes, format: :json
  #   get :show, id: @poll, users_answer_id: answer_yes.id.to_s, format: :json
  #   assert_response :success
  #   json = JSON.parse(response.body)
  #   assert_equal true, json['answers'][0]['users_vote']
  #   assert_equal false, json['answers'][1]['users_vote']
  # end

  test "should vote on an answer from the poll" do
    answer_no = Answer.new(title: 'no')
    @poll.answers = [Answer.new(title: 'yes'), answer_no]
    put :vote, id: @poll, answer_id: answer_no, format: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json['total_votes_count']
    assert_equal true, json['ip_has_voted']
    assert_equal 0, json['answers'][0]['vote_count']
    assert_equal false, json['answers'][0]['users_vote']
    assert_equal 1, json['answers'][1]['vote_count']
    assert_equal true, json['answers'][1]['users_vote']
  end

  test "should vote only once" do
    answer_no = Answer.new(title: 'no')
    @poll.answers = [Answer.new(title: 'yes'), answer_no]
    put :vote, id: @poll, answer_id: answer_no, format: :json
    put :vote, id: @poll, answer_id: answer_no, format: :json
    assert_response :unprocessable_entity
  end

end
