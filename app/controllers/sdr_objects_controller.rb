class SdrObjectsController < CrudController

  self.permitted_attrs = [:sdr_object_id,:object_type, :governing_object, :object_label, :latest_version]

end
