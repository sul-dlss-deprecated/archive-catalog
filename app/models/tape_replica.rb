class TapeReplica  < ActiveRecord::Base
  self.primary_key = :replica_id
  validates :replica_id, :presence => true
  belongs_to :replica, foreign_key: 'replica_id'
  belongs_to :tape_archive, foreign_key: 'tape_archive_id'

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{replica_id}"
  end

end