class TapeArchive  < ActiveRecord::Base
  self.primary_key = :tape_archive_id

  def to_s
    "#{tape_archive_id}"
  end

end