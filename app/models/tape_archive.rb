class TapeArchive  < ActiveRecord::Base
  self.primary_key = :tape_archive_id

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{tape_archive_id}"
  end

end