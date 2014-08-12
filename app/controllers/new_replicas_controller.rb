class NewReplicasController < CrudController

  self.permitted_attrs = [:replica_id, :home_repository, :create_date, :payload_size, :payload_fixity_type, :payload_fixity]

  self.default_sort = :replica_id

end
