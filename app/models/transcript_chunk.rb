class TranscriptChunk
  # this class is used to hold state about transcript fragments from a TEI file
  attr_accessor :fragment_name
  attr_accessor :speaker
  attr_accessor :start_in_seconds
  attr_accessor :text

  def initialize(fragment_name, speaker, start_in_seconds, text)
    @fragment_name = fragment_name
    @speaker = speaker
    @start_in_seconds = start_in_seconds
    @text = text
  end
end