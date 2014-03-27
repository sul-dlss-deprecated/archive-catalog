class SdrObject  < ActiveRecord::Base
  self.primary_key = :sdr_object_id
  belongs_to :digital_object, foreign_key:'digital_object_id'
  has_many :sdr_object_versions, foreign_key:'sdr_object_id'
  validates :sdr_object_id, :presence => true

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{sdr_object_id}"
  end

end