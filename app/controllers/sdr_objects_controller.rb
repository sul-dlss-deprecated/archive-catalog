class SdrObjectsController < CrudController

  self.permitted_attrs = [:sdr_object_id, :object_type, :governing_object, :object_label, :latest_version]

  self.default_sort = 'sdr_object_id'

  self.search_columns = [:sdr_object_id, :object_type, :governing_object]

end
