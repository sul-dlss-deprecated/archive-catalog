class DpnObjectsController < CrudController

  # Never trust parameters from the scary internet, only allow the white list through.
  self.permitted_attrs = [:dpn_object_id]

  self.default_sort = :dpn_object_id

end
