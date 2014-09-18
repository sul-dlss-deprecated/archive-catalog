# == Schema Information
#
# Table name: tape_archives
#
#  tape_archive_id :string(32)       not null, primary key
#  tape_server     :string(32)       not null
#  tape_node       :string(32)       not null
#  submit_date     :timestamp(6)     not null
#  accept_date     :timestamp(6)
#  verify_date     :timestamp(6)
#

class TapeArchive  < ActiveRecord::Base
  self.primary_key = :tape_archive_id
  validates :tape_archive_id, :presence => true

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{tape_archive_id}"
  end

end
