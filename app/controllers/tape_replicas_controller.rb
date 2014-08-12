class TapeReplicasController < CrudController

  self.permitted_attrs = [:replica_id, :tape_archive_id]

  self.default_sort = :replica_id

end
