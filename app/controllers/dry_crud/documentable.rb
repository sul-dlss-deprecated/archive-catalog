# encoding: UTF-8

module DryCrud

  module Documentable
    extend ActiveSupport::Concern

    # Generate the API Documentation
    #
    #   GET /entries/1
    #   GET /entries/1.json
    def apidoc(&block)
      @documentation = documentation
      respond_with(@documentation, &block)
    end

    def is_editable?
      table_descriptions.keys.include?(params[:controller].to_s)
    end


    private

    def documentation
      {
          table: table_properties,
          columns: table_columns,
          actions: table_actions,
          formats: output_formats
      }
    end

    def table_properties
      table_name = params[:controller]
      {
          name: table_name,
          description: tables_and_views[table_name.to_sym],
          primary_key: model_class.primary_key
      }
    end

    def tables_and_views
      @@tables_and_views ||= table_descriptions.merge(view_descriptions)
    end

    def table_descriptions
      @@table_descriptions ||= {
          digital_objects:
              "All SDR and DPN objects preserved in SDR Core",
          sdr_objects:
              "Inventory of SDR objects preserved in SDR Core",
          sdr_object_versions:
              "Inventory of all versions of SDR objects",
          sdr_version_stats:
              "Size metrics for SDR object versions",
          replicas:
              "Containerized copies of object/versions (to be) archived to tape",
          tape_replicas:
              "Join table indicating which replicas were archived in which tape archive",
          tape_archives:
              "A container holding multiple replicas which was archived to tape",
          dpn_objects:
              "Inventory of objects from DPN that were archived to tape"
      }
    end

    def view_descriptions
      @@view_descriptions ||= {
          new_replicas:
              "Replicas not yet archived to tape"
      }
    end

    def table_columns
      self.permitted_attrs.map do |column_name|
        {column_name: column_name}.merge(column_descriptions[column_name.to_sym])
      end
    end

    def column_descriptions
      @@column_descriptions ||= {
          :accept_date => {
              :data_type => "timestamp(6) with time zone",
              :nullable => "yes",
              :description => "The date and time that the replica was accepted for replication"
          },
          :content_blocks => {
              :data_type => "number",
              :nullable => "no",
              :description => "Total disk space occupied by the content files"
          },
          :content_bytes => {
              :data_type => "number",
              :nullable => "no",
              :description => "Total size of content files in the object"
          },
          :content_files => {
              :data_type => "number",
              :nullable => "no",
              :description => "Number of content files in the object"
          },
          :create_date => {
              :data_type => "timestamp(6) with time zone",
              :nullable => "no",
              :description => "The date and time that the replica was created"
          },
          :digital_object_id => {
              :data_type => "varchar2(40 byte)",
              :nullable => "no",
              :description => "Either the SDR druid or the DPN UUID"
          },
          :dpn_object_id => {
              :data_type => "varchar2(40 byte)",
              :nullable => "no",
              :description => "The unique idenfier of the DPN object"
          },
          :governing_object => {
              :data_type => "varchar2(17 byte)",
              :nullable => "yes",
              :description => "SDR Druid of the APO the object is governed by"
          },
          :home_repository => {
              :data_type => "varchar2(3 byte)",
              :nullable => "no",
              :description => "The source location of the object/version (sdr or dpn)"
          },
          :ingest_date => {
              :data_type => "timestamp(6) with time zone",
              :nullable => "yes",
              :description => "The date and time that the object/version was ingested"
          },
          :inventory_type => {
              :data_type => "varchar2(5 byte)",
              :nullable => "no",
              :description => "The type of file inventory of the object/version (full or delta)"
          },
          :latest_version => {
              :data_type => "number",
              :nullable => "yes",
              :description => "The sdr_version_id of the latest version of an object"
          },
          :metadata_blocks => {
              :data_type => "number",
              :nullable => "no",
              :description => "Total disk space occupied by the metadata files"
          },
          :metadata_bytes => {
              :data_type => "number",
              :nullable => "no",
              :description => "Total size of metadata files in the object"
          },
          :metadata_files => {
              :data_type => "number",
              :nullable => "no",
              :description => "Number of metadata files in the object"
          },
          :object_label => {
              :data_type => "varchar2(100 byte)",
              :nullable => "yes",
              :description => "The title or other human readable description of the object"
          },
          :object_type => {
              :data_type => "varchar2(20 byte)",
              :nullable => "no",
              :description => "Simplest outermost taxonomy of the digital object (e.g. agreement,apo,collection,item)"
          },
          :payload_fixity => {
              :data_type => "varchar2(64 byte)",
              :nullable => "no",
              :description => "The checksum measured for the replica's tar file"
          },
          :payload_fixity_type => {
              :data_type => "varchar2(7 byte)",
              :nullable => "no",
              :description => "The type of algorithm used for checksums"
          },
          :payload_size => {
              :data_type => "number",
              :nullable => "no",
              :description => "The size (in bytes) of the replica's tar file"
          },
          :replica_id => {
              :data_type => "varchar2(40 byte)",
              :nullable => "no",
              :description => "The unique identifier for the replica, e.g. DPN ID, or concatenation of druid and version id"
          },
          :sdr_object_id => {
              :data_type => "varchar2(17 byte)",
              :nullable => "no",
              :description => "The object druid, including the prefix"
          },
          :sdr_version_id => {
              :data_type => "number",
              :nullable => "no",
              :description => "The object's version number, e.g. 1,2...n"
          },
          :submit_date => {
              :data_type => "timestamp(6) with time zone",
              :nullable => "no",
              :description => "The date and time that the replica was submitted for replication"
          },
          :tape_archive_id => {
              :data_type => "varchar2(32 byte)",
              :nullable => "no",
              :description => "The identifier (and directory name) of the tape archive bucket"
          },
          :tape_node => {
              :data_type => "varchar2(32 byte)",
              :nullable => "no",
              :description => "The tape node used to archive the object"
          },
          :tape_server => {
              :data_type => "varchar2(32 byte)",
              :nullable => "no",
              :description => "The tape server used to archive the object"
          },
          :verify_date => {
              :data_type => "timestamp(6) with time zone",
              :nullable => "yes",
              :description => "The date and time that the replica was confirmed to be replicated"
          }
      }
    end

    def table_actions
      table = params[:controller]
      view_actions = [
          {
              http: "GET",
              route: "#{table}/apidoc(.:format)",
              controller: "apidoc",
              description: "Generate API documentation for #{table} (this page)"
          },
          {
              http: "GET",
              route: "#{table}(.:format)",
              controller: "index",
              description: "List the #{table} members. Use query parameters to customize the list."
          },
          {
              http: "GET",
              route: "#{table}/:id(.:format)",
              controller: "show",
              description: "Display the data for a single table row, using the primary key for lookup"
          }
      ]
      edit_actions = []
      if table_descriptions.has_key?(table.to_sym)
        edit_actions = [
            {
                http: "POST",
                route: "#{table}(.:format)",
                controller: "create",
                description: "Insert a new table row, or update the existing entry if found using the primary key"
            },
            {
                http: "PATCH",
                route: "#{table}/:id(.:format)",
                controller: "update",
                description: "Update an existing record"
            },
            {
                http: "GET",
                route: "#{table}/new(.:format)",
                controller: "new",
                description: "Request a form that allows input of data for table row to be added. (html format only)"
            },
            {
                http: "GET",
                route: "#{table}/:id/edit(.:format)",
                controller: "edit",
                description: "Request a form that allows edit of data for table row to be updated. (html format only)"
            },
            {
                http: "DELETE",
                route: "#{table}/:id(.:format)",
                controller: "destroy",
                description: "Delete an existing record. ToDo: disable this method?"
            }
        ]
      end
      view_actions + edit_actions
    end

    def output_formats
      {
          html: '(default) Input data using HTML form, output data using HTML table.  ' +
              'Used for administrative interface.  Lists are automatically paginated.  ' +
              'Sort order can be specified using the &order=column_name[+...] query parameter',
          json: 'Input/Output data in JSON format.  The preferred interface for REST clients. ' +
              'Use query parameters to control the output, e.g. use limit=n when retrieving lists.  '
      }
    end

  end

end