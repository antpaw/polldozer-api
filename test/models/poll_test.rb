require 'test_helper'

class PollTest < ActiveSupport::TestCase
  teardown do
    @poll.delete
  end

  test 'do not save without answers' do
    @poll = polls(:empty_answers)
    assert_not @poll.save
  end

  test 'creates a poll' do
    @poll = polls(:start)
    @poll.answers = [Answer.new(title: 'yes'), Answer.new(title: 'no')]
    assert @poll.save
  end

  test 'description' do
    @poll = polls(:start)
    @poll.answers = [Answer.new(title: 'yes'), Answer.new(title: 'no')]
    assert_equal 'a) yes, b) no', @poll.description
  end

  test 'total_votes_count' do
    @poll = polls(:start)
    assert_equal 0, @poll.total_votes_count
    @poll.answers = [Answer.new(title: 'yes'), Answer.new(title: 'no')]
    @poll.vote_answer(@poll.answers.first.id, '1')
    @poll.vote_answer(@poll.answers.first.id, '2')
    @poll.vote_answer(@poll.answers.last.id, '3')
    assert_equal 3, @poll.total_votes_count, @poll.errors.to_a
  end

  test 'is_finished is false on create' do
    @poll = polls(:start)
    assert_not @poll.is_finished?
  end

  test 'is_finished false' do
    @poll = polls(:start)
    @poll.valid_until = 5.days.from_now
    assert_not @poll.is_finished?
  end

  test 'is_finished true' do
    @poll = polls(:start)
    @poll.valid_until = 1.days.ago
    assert @poll.is_finished?
  end

  test 'set_valid_until_from_offset' do
    @poll = polls(:start)
    @poll.set_valid_until_from_offset({
      days: 2,
      hours: 2,
      minutes: 4
    })
    assert @poll.valid_until > 2.days.from_now + 2.hours + 2.minutes
    assert @poll.valid_until < 2.days.from_now + 2.hours + 6.minutes
  end

  test 'set_answers_status no winner if equal votes' do
    @poll = polls(:start)
    @poll.valid_until = 2.days.ago
    @poll.answers = [Answer.new(title: 'yes'), Answer.new(title: 'no'), Answer.new(title: 'maybe'), Answer.new(title: 'hell no')]
    @poll.vote_answer(@poll.answers[0].id, '1')
    @poll.vote_answer(@poll.answers[1].id, '2')
    @poll.vote_answer(@poll.answers[2].id, '3')
    @poll.set_answers_status
    assert_equal false, @poll.answers[0].winner
    assert_equal false, @poll.answers[1].winner
    assert_equal false, @poll.answers[2].winner
    assert_equal false, @poll.answers[3].winner
  end

  test 'set_answers_status no winner not finished' do
    @poll = polls(:start)
    @poll.valid_until = 2.days.from_now
    @poll.answers = [Answer.new(title: 'yes'), Answer.new(title: 'no'), Answer.new(title: 'maybe'), Answer.new(title: 'hell no')]
    @poll.vote_answer(@poll.answers[0].id, '1')
    @poll.vote_answer(@poll.answers[2].id, '3')
    @poll.set_answers_status
    assert_equal nil, @poll.answers[0].winner
    assert_equal nil, @poll.answers[1].winner
    assert_equal nil, @poll.answers[2].winner
    assert_equal nil, @poll.answers[3].winner
  end

  test 'set_answers_status has winner' do
    @poll = polls(:start)
    @poll.valid_until = 2.days.ago
    @poll.answers = [Answer.new(title: 'yes'), Answer.new(title: 'no'), Answer.new(title: 'maybe'), Answer.new(title: 'hell no')]
    @poll.vote_answer(@poll.answers[0].id, '1')
    @poll.vote_answer(@poll.answers[0].id, '2')
    @poll.vote_answer(@poll.answers[2].id, '3')
    @poll.set_answers_status
    assert_equal true, @poll.answers[0].winner
    assert_equal false, @poll.answers[1].winner
    assert_equal false, @poll.answers[2].winner
    assert_equal false, @poll.answers[3].winner
  end

  test 'has_voted?' do
    @poll = polls(:start)

    assert @poll.has_voted?(nil)
    assert_not @poll.has_voted?('blub')
    @poll.answers = [Answer.new(title: 'yes')]
    @poll.vote_answer(@poll.answers.first.id, 'blub')
    assert @poll.has_voted?('blub')
  end
end
