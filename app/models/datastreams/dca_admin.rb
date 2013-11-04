class DcaAdmin < ActiveFedora::OmDatastream
  set_terminology do |t|
    t.root(:path => "admin", 'xmlns'=>"http://nils.lib.tufts.edu/dcaadmin/", 'xmlns:ac'=>"http://purl.org/dc/dcmitype/")

    t.steward index_as: :stored_searchable
    t.name namespace_prefix: "ac", index_as: :stored_searchable
    t.comment namespace_prefix: "ac", index_as: :stored_searchable
    t.retentionPeriod index_as: :stored_searchable
    t.displays index_as: :stored_searchable
    t.embargo index_as: :dateable
    t.status index_as: :stored_searchable
    t.startDate index_as: :stored_searchable
    t.expDate index_as: :stored_searchable
    t.qrStatus index_as: :stored_searchable
    t.rejectionReason index_as: :stored_searchable
    t.note index_as: :stored_searchable

    t.published_at(:path => "publishedAt", :type=>:time, index_as: :stored_sortable)
    t.edited_at(:path => "editedAt", :type=>:time, index_as: :stored_sortable)
  end

  # BUG?  Extra solr fields are generated when there is a default namespace (xmlns) declared on the root.
  #   compared to when the root has a namespace and the child elements do not have an namespace.
  # BUG?  There's never more than one root node, so why do admin_0_published_at_dtsi  ?

  def self.xml_template
    Nokogiri::XML('<admin xmlns="http://nils.lib.tufts.edu/dcaadmin/" xmlns:ac="http://purl.org/dc/dcmitype/"/>')
  end

  #def to_solr(solr_doc = Hash.new)
  #     super
  #        unless self.embargo.map.count == 0 || self.embargo.map[0].blank?
  #           dt = self.embargo.map[0]
  #           iso_date = "#{dt}T13:00:00:00Z"
  #           unless iso_date[/^T13/]
  #            ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "embargo_dt", iso_date)
  #           end
  #         end
  #     solr_doc
  # end
end
