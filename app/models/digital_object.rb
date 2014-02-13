class DigitalObject < ActiveRecord::Base
  self.primary_key = :digital_object_id

  def to_s
    :digital_object_id.to_s
  end

end
