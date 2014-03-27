class Replica  < ActiveRecord::Base
  self.primary_key = :replica_id
  validates :replica_id, :presence => true

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{replica_id}"
  end

end