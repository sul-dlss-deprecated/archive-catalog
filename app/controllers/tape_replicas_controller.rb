class TapeReplicasController < CrudController

  self.permitted_attrs = [:replica_id, :tape_archive_id]

  self.default_sort = 'replica_id'

  self.search_columns = [:replica_id, :tape_archive_id]

end
