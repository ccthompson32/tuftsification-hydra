class TuftsTEI < TuftsBase

  #MK 2011-04-13 - Are we really going to need to access FILE-META from FILE-META.  I'm guessing
  # not.

 # has_metadata :name => "Archival.xml", :type => TuftsRcrMeta
  has_metadata "Archival.xml", type: TuftsTeiMeta

  def to_solr(solr_doc=Hash.new, opts={})
    super
    return solr_doc
  end

end
