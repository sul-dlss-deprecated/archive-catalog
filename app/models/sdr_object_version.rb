class SdrObjectVersion  < ActiveRecord::Base
  self.primary_keys = :sdr_object_id, :sdr_object_version
  belongs_to :sdr_object

  # Output a human-friendly label for this entity in captions (e.g. for html titles )
  def to_s
    "#{sdr_object_id}-#{version_dirname}"
  end

  # @return [String] The text label of the version, e.g 'v0002'
  def version_dirname
    ("v%04d" % sdr_object_version)
  end

end