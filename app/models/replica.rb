# == Schema Information
#
# Table name: replicas
#
#  replica_id          :string(40)       not null, primary key
#  home_repository     :string(3)        not null
#  create_date         :timestamp(6)     not null
#  payload_fixity_type :string(7)        not null
#  payload_fixity      :string(64)       not null
#  payload_size        :integer          not null
#

class Replica  < ActiveRecord::Base
  self.primary_key = :replica_id
  validates :replica_id, :presence => true

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{replica_id}"
  end

end
