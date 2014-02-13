class DpnObject < ActiveRecord::Base
  self.primary_key = :dpn_object_id

  def to_s
    :dpn_object_id.to_s
  end

end
