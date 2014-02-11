class SdrObjectVersion  < ActiveRecord::Base
  self.primary_keys = :sdr_object_id, :sdr_object_version
end