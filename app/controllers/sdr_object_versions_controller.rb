class SdrObjectVersionsController < CrudController

  self.permitted_attrs = [:sdr_object_id, :sdr_object_version, :ingest_date, :replica_id]

  self.default_sort = 'sdr_object_id', 'sdr_object_version'

end
