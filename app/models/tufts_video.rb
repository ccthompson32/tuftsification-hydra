class TuftsVideo < TuftsBase
  has_metadata "ARCHIVAL_XML", type: TuftsAudioTextMeta
  has_file_datastream 'Thumbnail.png', control_group: 'E'
  has_file_datastream 'Archival.video', control_group: 'E', original: true
  has_file_datastream 'Access.webm', control_group: 'E'
  has_file_datastream 'Access.mp4', control_group: 'E'

  def file_path(name, extension = nil)
    case name
    when 'Thumbnail.png', 'ARCHIVAL_XML', 'Archival.video','Access.webm','Access.mp4'
      if self.datastreams[name].dsLocation
        self.datastreams[name].dsLocation.sub(Settings.trim_bucket_url + '/' + object_store_path, "")
      else
        raise ArgumentError, "Extension required for #{name}" unless extension
        File.join(directory_for(name), "#{pid_without_namespace}.archival.#{extension}")
      end
    else
      File.join(directory_for(name), "#{pid_without_namespace}.#{name.downcase.sub('_', '.')}")
    end
  end

  def to_solr(solr_doc=Hash.new, opts={})
    super
    return solr_doc
  end

end
