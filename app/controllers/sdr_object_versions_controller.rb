class SdrObjectVersionsController < CrudController

  self.permitted_attrs = [:sdr_object_id, :sdr_version_id, :ingest_date, :replica_id]

  self.default_sort = :replica_id

end
