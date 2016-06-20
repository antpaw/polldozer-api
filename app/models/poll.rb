class Poll
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :token, type: Array
  field :valid_until, type: DateTime, default: -> { 1.day.from_now }
  embeds_many :answers

  validates :title, presence: true
  validates :answers, presence: true
  validate :valid_until_check, on: :create

  def valid_until_check
    if valid_until < 4.minutes.from_now
      errors.add(:valid_until, :must_be_future)
    end
    if valid_until > 10.days.from_now
      errors.add(:valid_until, :no_too_far_in_future)
    end
  end

  def description
    abc = ('a'..'z').to_a
    output = []
    answers.each_with_index do |answer, i|
      output << "#{abc[i]}) #{answer.title}"
    end
    output.join(', ')
  end

  def vote_answer(answer_id, has_voted)
    if has_voted
      errors.add(:base, :has_voted)
      return false
    end
    unless answer = answers.find(answer_id)
      errors.add(:answer_id, :not_found)
      return false
    end
    answer.vote
    answer
  end

  def total_votes_count
    answers.pluck(:vote_count).sum
  end

  def is_finished?
    Time.now > valid_until
  end

  def set_valid_until_from_offset(date_offset)
    return  unless date_offset
    date = Time.now()
    date += date_offset[:days].to_i.days if date_offset[:days].present?
    date += date_offset[:hours].to_i.hours if date_offset[:hours].present?
    date += date_offset[:minutes].to_i.minutes if date_offset[:minutes].present?
    self.valid_until = date
  end

  def set_ip_has_voted(boolean)
    @ip_has_voted = boolean
  end

  def ip_has_voted
    @ip_has_voted
  end

  def set_answers_percent
    sum = total_votes_count
    answers.each do |answer|
      answer.set_percent_from_sum(sum)
    end
  end

  def set_answers_status
    if is_finished?
      answers.each(&:set_as_loser)
      winner_answer = answers.max_by(&:vote_count)
      if answers.one? { |answer| answer.vote_count == winner_answer.vote_count }
        winner_answer.set_as_winner()
      end
    end
  end

  def set_users_vote_for_answer(answer_id)
    answers.each(&:set_users_vote_no)
    selected_answer = answers.bsearch { |answer| answer.id == answer_id }
    if selected_answer
      selected_answer.set_users_vote_yes()
    end
  end

  def set_answers(answer_titles)
    answer_titles.each do |answer_title|
      self.answers << Answer.new(title: answer_title)
    end
  end

  def has_token?(param_token)
    false #self.contains(:token, param_token)
  end

end
