# == Schema Information
#
# Table name: new_replicas
#
#  replica_id          :string(40)       not null, primary key
#  home_repository     :string(3)        not null
#  create_date         :timestamp(6)     not null
#  payload_size        :integer          not null
#  payload_fixity_type :string(7)        not null
#  payload_fixity      :string(64)       not null
#


# CREATE OR REPLACE FORCE VIEW "SEDORA_DEV"."NEW_REPLICAS" ("REPLICA_ID", "HOME_REPOSITORY", "CREATE_DATE", "PAYLOAD_SIZE", "PAYLOAD_FIXITY_TYPE", "PAYLOAD_FIXITY")
# AS
#   SELECT r.replica_id ,
#     r.home_repository,
#     r.create_date ,
#     r.payload_size,
#     r.payload_fixity_type,
#     r.payload_fixity
#   FROM replicas r
#   LEFT JOIN tape_replicas t
#   ON r.replica_id = t.replica_id
#   WHERE t.tape_archive_id IS NULL;
# @see http://www.codeproject.com/Articles/33052/Visual-Representation-of-SQL-Joins
class NewReplica  < ActiveRecord::Base
  self.primary_key = :replica_id

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{replica_id}"
  end

end
