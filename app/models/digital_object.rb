class DigitalObject < ActiveRecord::Base
  self.primary_key = :digital_object_id

  # @return [String] the %{model} instance identifier string used in flashes or other captions.  See config/locales files
  def to_s
    "#{digital_object_id}"
  end

end
