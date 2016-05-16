json._id @poll.id.to_s
json.title @poll.title
json.valid_until @poll.valid_until.to_i
json.finished @poll.is_finished?
json.total_votes_count @poll.total_votes_count
json.ip_has_voted @poll.ip_has_voted

json.answers @poll.answers do |answer|
  json._id answer.id.to_s
  json.title answer.title
  json.vote_count answer.vote_count
  json.percent_total answer.percent_total
  json.winner answer.winner
end
