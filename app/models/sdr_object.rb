class SdrObject  < ActiveRecord::Base
  self.primary_key = :sdr_object_id
  belongs_to :digital_object, primary_key: 'sdr_object_id', foreign_key: 'digital_object_id'
  has_many :sdr_object_versions

  def to_s
    "#{sdr_object_id}"
  end

end