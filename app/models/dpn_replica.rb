class DpnReplica  < ActiveRecord::Base
  self.primary_key = :replica_id
  validates :replica_id, :presence => true
  belongs_to :replica, foreign_key: 'replica_id'

  def to_s
    "#{replica_id}"
  end

end