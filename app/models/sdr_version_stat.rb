class SdrVersionStat  < ActiveRecord::Base
  self.primary_keys = :sdr_object_id, :sdr_version_id, :inventory_type
  belongs_to :sdr_object_version, :foreign_key => [:sdr_object_id, :sdr_version_id]
  validates :sdr_object_version, :presence => true
  validates :sdr_object_id, :presence => true
  validates :sdr_version_id, :presence => true
  validates :inventory_type, :presence => true

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{sdr_object_id}-#{version_dirname}"
  end

  # @return [String] The text label of the version, e.g 'v0002'
  def version_dirname
    ("v%04d" % sdr_version_id)
  end

end