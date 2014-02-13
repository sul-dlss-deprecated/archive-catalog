class Replica  < ActiveRecord::Base
  self.primary_key = :replica_id
  validates :replica_id, :presence => true

  def to_s
    "#{replica_id}"
  end

end