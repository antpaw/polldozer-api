class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :poll

  field :title, type: String
  field :vote_count, type: Integer, default: 0

  validates :title, presence: true

  def vote
    update_attribute(:vote_count, vote_count + 1)
  end

  def set_percent_from_sum(sum)
    @percent = if sum > 0 && vote_count > 0
      vote_count.to_f / (sum.to_f / 100.0)
    else
      0.0
    end.round
    @percent
  end

  def percent
    @percent
  end

  def winner
    @winner
  end

  def set_as_winner
    @winner = true
  end

  def set_as_loser
    @winner = false
  end

  def users_vote
    @users_vote
  end

  def set_users_vote_yes
    @users_vote = true
  end

  def set_users_vote_no
    @users_vote = false
  end
end
