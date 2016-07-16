json._id @poll.id.to_s
json.title @poll.title
json.valid_until @poll.valid_until.to_i
json.created_at @poll.created_at.to_i
json.finished @poll.is_finished?
json.total_votes_count @poll.total_votes_count
json.ip_has_voted @poll.ip_has_voted
if @vote
  json.vote_id @vote.id.to_s
end

json.answers @poll.answers do |answer|
  json._id answer.id.to_s
  json.title answer.title
  json.vote_count answer.vote_count
  json.percent answer.percent
  if answer.winner == true or answer.winner == false
    json.winner answer.winner
  end
  if answer.users_vote == true or answer.users_vote == false
    json.users_vote answer.users_vote
  end
end
