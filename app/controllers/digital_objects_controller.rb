class DigitalObjectsController < CrudController

  # Never trust parameters from the scary internet, only allow the white list through.
  self.permitted_attrs = [:digital_object_id, :home_repository]

  self.default_sort = 'digital_object_id'

  self.search_columns = [:digital_object_id, :home_repository]

end
