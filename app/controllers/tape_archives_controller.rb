class TapeArchivesController < CrudController

  self.permitted_attrs = [:tape_archive_id, :tape_server, :tape_node, :submit_date, :accept_date, :verify_date]

  self.default_sort = :tape_archive_id

end
