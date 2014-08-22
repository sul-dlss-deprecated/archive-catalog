class ApidocController < ApplicationController
  include DryCrud::Documentable

  respond_to :html, :json

  def index
    @title = 'Tables & Views'
    @tables_and_views = {
        tables: table_descriptions,
        views: view_descriptions
    }
    respond_with(@tables_and_views)
  end

  def querydoc(&block)
    @title = 'Search/Query Documentation for Archive Catalog'
    @query_documentation = query_documentation
    respond_with(@query_documentation, &block)
  end

  private

  def query_documentation
    {
        queries: query_parameters,
        examples: query_examples
    }
  end

  def query_parameters
    {
        general: {
            purpose: 'Query parameter are used to specify the subset and rendering of data to be retrieved and displayed',
            delimiters: 'URIs have a very restrictive character set, therefore the query parameter syntax ' +
                'makes use of period (.), plus (+), and tilde (~) as delimeters in place of space and comma. ' +
                'Periods are used to modify a column name specification or create a conditional predicate. ' +
                'Plus signs are used when you would normally use a comma for listing items.  ' +
                'Tildes are used to delimit the sections of a complex conditional expression, making them easier to parse.s'
        },
        select: {
            purpose: 'Used to specify column names to be displayed in output, with optional aggregation expressions',
            syntax: '{column_name}[.{aggregation_operator}[.distinct]][+...]',
            aggregation_operators: 'average, count, minimum, maximum, sum',
            examples: "select=c1+c2+c3 ;; select=c1.count+c2.sum ;; select=c2+c1.count.distinct"
        },
        where: {
            purpose: 'Used to filter the rows selected, based on the specified criteria. ' +
                'Simplest criterion is a simple predicate consisting of a column_name, predicate operator, and a value ',
            predicate_syntax: '{column_name}.{predicate_operator}.{value}',
            predicate_operators: 'eq, gt, gteq, in, lt, lteq, matches, not_eq, not_in',
            compound_predicate_syntax: '{predicate}&{boolean_operator}&{predicate}[&{boolean_operator}&{predicate}...]',
            boolean_operators: 'and, or',
            grouping_syntax: '({compound_predicate})',
            grouping_operator: '( )',
            negation_syntax: '{negation_operator}&({compound_predicate})',
            negation_operator: 'not',
            examples: 'where=c1.eq.v1 ;; where=c2.lt.v2 ;; where=c3.in.a+b+c ;; where=c4.matches.substr ;;  ' +
                'where=c1.eq.v1~and~c2.lt.v2~or~c3.in.a+b+c # ~and~ has precedence ;;  ' +
                'where=c1.eq.v1~and~not~(c2.eq.v2~or~c3.in.a+b+c) # forces ~or~ precedence'
        },
        order: {
            purpose: 'Used to override the default sort order',
            syntax: '{column_name}[.{direction_operator}][+...]',
            direction_operators: 'asc, desc  (asc is default)',
            examples: 'order=c1+c2 ;; order=c1.desc+c2.asc'
        },
        limit: {
            purpose: 'Used to return the specified number of item records',
            syntax: '{integer}',
            examples: 'limit=50'
        },
        offset: {
            purpose: 'Used to skip over the specified number of records before returning items',
            syntax: '{integer}',
            examples: 'offset=100&limit=100'
        }
    }
  end

  def query_examples
       [
            {
                uri: "digital_objects",
                sql: "select * from sdr_objects order by digital_object_id"
            },
            {
                uri: "digital_objects.json?select=home_repository+digital_object_id.count.distinct",
                sql:  "select home_repository, count(distinct digital_object_id) \n" +
                      "as count_d_digital_object_id from digital_objects \n" +
                      "group by home_repository  order by home_repository"
            },
            {
                uri: "sdr_objects",
                sql: "select * from sdr_objects order by sdr_object_id"
            },
            {
                uri: "sdr_objects/druid:bb002dn7936.json",
                sql: "select * from sdr_objects \n" +
                      "where sdr_object_id = 'druid:bb002dn7936'"
            },
            {
                uri: "sdr_objects.json?where=governing_object.eq.druid:fg586rn4119&limit=3",
                sql: "select * from sdr_objects \n" +
                      "where governing_object = 'druid:fg586rn4119' \n" +
                      "and rownum <= 3"
            },
            {
                uri: "sdr_objects.json?offset=20&limit=4",
                sql: "select * from ( \n" +
                     "  select raw_sql_.*, rownum raw_rnum from ( \n" +
                     "    select  * from sdr_objects) raw_sql_ where rownum <= 24 \n" +
                     "  ) where raw_rnum_ > 20"
},
            {
                uri: "sdr_objects.json?select=sdr_object_id+object_type&limit=5",
                sql: "select * from (select  sdr_object_id, object_type from sdr_objects \n" +
                     "order by sdr_object_id) where rownum <= 5"
            },
            {
                uri: "sdr_objects.json?select=object_type+sdr_object_id.count",
                sql: "select object_type, count(sdr_object_id) as count_sdr_object_id \n" +
                     "from sdr_objects group by object_type order by object_type"
            },
            {
                uri: "sdr_objects.json?select=latest_version+sdr_object_id.count",
                sql: "select latest_version, count(sdr_object_id) as count_sdr_object_id \n" +
                     "from sdr_objects  group by latest_version  order by latest_version"
            },
            {
                uri: "sdr_object_versions",
                sql: "select * from sdr_object_versions order by sdr_object_id,sdr_version_id"
            },
            {
                uri: "sdr_object_versions/druid:th568hj8383,1.json",
                sql: "select * from sdr_object_versions \n" +
                     "where (sdr_object_id = 'druid:th568hj8383' and sdr_version_id = 1) \n" +
                     "and rownum <= 1 "
            },
            {
                uri: "sdr_object_versions.json?select=sdr_version_id+sdr_object_id.count",
                sql: "select sdr_version_id, count(sdr_object_id) as count_sdr_object_id \n" +
                     "from sdr_object_versions \n" +
                     "group by sdr_version_id order by sdr_version_id"
            },
            {
                uri: "sdr_version_stats",
                sql: "select * from sdr_version_stats \n" +
                     "order by sdr_object_id,sdr_version_id,inventory_type"
            },
            {
                uri: "sdr_version_stats/druid:th568hj8383,1,delta.json",
                sql: "select * from sdr_version_stats  \n" +
                      "where (sdr_object_id = 'druid:th568hj8383' \n" +
                     "and sdr_version_id = 1 and inventory_type = 'delta') \n" +
                     "and rownum <= 1"
            },
            {
                uri: "sdr_version_stats.json?select=content_files.sum+content_bytes.sum" +
                    "+content_blocks.sum+metadata_files.sum+metadata_bytes.sum+metadata_blocks.sum" +
                    "&where=inventory_type.eq.full~and~sdr_version_id.eq.1",
                sql: "select sum(content_files) as sum_content_files, \n" +
                     "sum(content_bytes) as sum_content_bytes, \n" +
                     "sum(content_blocks) as sum_content_blocks, \n" +
                     "sum(metadata_files) as sum_metadata_files, \n" +
                     "sum(metadata_bytes) as sum_metadata_bytes, \n" +
                     "sum(metadata_blocks) as sum_metadata_blocks \n" +
                     "from sdr_version_stats  \n" +
                     "where (inventory_type = 'full' and sdr_version_id = 1)"
            },
            {
                uri: "sdr_version_stats.json?select=metadata_bytes+sdr_object_id.count.distinct&where=metadata_bytes.in.6556+6558",
                sql: "select metadata_bytes, \n "+
                     "count(distinct sdr_object_id) as count_d_sdr_object_id \n "+
                     "from sdr_version_stats  where metadata_bytes in (6556, 6558) \n "+
                     "group by metadata_bytes  order by metadata_bytes"
            },
            {
                uri: "replicas",
                sql: "select * from replicas order by replica_id"
            },
            {
                uri: "replicas?order=payload_size.desc",
                sql: "select * from replicas order by payload_size desc"
            }
        ]
  end

end
