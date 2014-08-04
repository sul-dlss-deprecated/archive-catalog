class DpnReplicasController < CrudController

  self.permitted_attrs = [:replica_id, :dpn_object_id, :submit_date, :accept_date, :verify_date]

  self.default_sort = 'replica_id'

  self.search_columns = [:replica_id, :dpn_object_id]

end
