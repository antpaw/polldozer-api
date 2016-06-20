require 'test_helper'

class VoteTest < ActiveSupport::TestCase

  setup do
    votes(:vote1).save
    votes(:vote2).save
    votes(:vote3).save
    votes(:vote4).save
    votes(:vote5).save
    votes(:vote6).save
    votes(:vote7).save
    votes(:vote8).save
  end

  teardown do
    Vote.all.destroy
  end

  test 'ip_has_too_many_vote_in_poll is true' do
    assert Vote.ip_has_too_many_vote_in_poll('126.0.0.1', '1')
  end

  test 'ip_has_too_many_vote_in_poll is false' do
    assert_not Vote.ip_has_too_many_vote_in_poll('126.0.0.1', '2')
    assert_not Vote.ip_has_too_many_vote_in_poll('125.0.0.1', '1')
  end
end
