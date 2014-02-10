class DigitalObjectsController < CrudController

  # Never trust parameters from the scary internet, only allow the white list through.
  self.permitted_attrs = [:digital_object_id,:home_repository]

end
