class SdrObjectVersionsController < CrudController

  self.permitted_attrs = [:sdr_object_id, :sdr_version_id, :ingest_date, :replica_id]

  self.default_sort = 'sdr_object_id', 'sdr_version_id'

  self.search_columns = [:sdr_object_id]

end
