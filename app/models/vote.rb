class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ip_address, type: String
  field :answer_id, type: BSON::ObjectId
  field :poll_id, type: BSON::ObjectId


  def self.ip_has_too_many_vote_in_poll(ip, poll_id)
    where(poll_id: poll_id, ip_address: ip).count > 5
  end

end
