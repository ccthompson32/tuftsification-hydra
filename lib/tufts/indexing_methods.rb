module Tufts
  module IndexingMethods
    def create_facets(solr_doc)
          index_names_info(solr_doc)
          index_subject_info(solr_doc)
          index_collection_info(solr_doc)
          index_date_info(solr_doc)
          index_format_info(solr_doc)
          index_pub_date(solr_doc)
          index_unstemmed_values(solr_doc)
    end
  end
end