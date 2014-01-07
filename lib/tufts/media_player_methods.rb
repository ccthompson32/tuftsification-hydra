require 'settingslogic'
require 'sprockets/railtie'

module Tufts
  module MediaPlayerMethods
  include Sprockets::Helpers::RailsHelper

    def self.show_audio_player(pid, withTranscript)
      result = "<div id='player_container'>\n"
      result += "        <div id='jw_player'>\n"
      result += "          This div will be replaced by the JW Player.\n"
      result += "        </div>\n"
      result += "        <div id='controls'></div>\n"
      result += "      </div>\n"
      result += "      <script type='text/javascript'>\n"
      result += "        jwplayer('jw_player').setup({\n"

			if (withTranscript)
      	result += "          events: {\n"
      	result += "            onPlay: chooseTranscriptTab,\n"
      	result += "            onTime: scrollTranscript\n"
      	result += "          },\n"
      end

      result += "          levels: [\n"
      result += "            {file: '/file_assets/" + pid + "', type: 'audio/mpeg'}\n"
      result += "          ],\n"
      result += "          width: 240,\n"
      result += "          height: 34,\n" # height <= 30 is the way to tell jwplayer to be audio-only
      result += "          flashplayer: \"/assets/jwplayer6/jwplayer.flash.swf\",\n" 
      result += "          primary: 'flash',\n"
      result += "          controls: false\n" # this seems to be ignored by jwplayer in audio-only mode
      result += "        });\n"
      result += "      </script>\n"

      return result
    end


    def self.show_video_player(pid, withTranscript,primary="html5")
       result = "<div id='player_container'>\n"
       result += "        <div id='jw_player'>\n"
       result += "          This div will be replaced by the JW Player.\n"
       result += "        </div>\n"
       result += "        <div id='controls'></div>\n"
       result += "      </div>\n"
       result += "      <script type='text/javascript'>\n"
       result += "        jwplayer('jw_player').setup({\n"

 			if (withTranscript)
       	result += "          events: {\n"
       	result += "            onPlay: chooseTranscriptTab,\n"
       	result += "            onTime: scrollTranscript\n"
       	result += "          },\n"
       end

       result += "          levels: [\n"
       result += "            {file: '/file_assets/" + pid + "', type: 'video/mp4'},\n"
       result += "            {file: '/file_assets/webm/" + pid + "', type: 'video/webm'}\n"
       result += "          ],\n"
       result += "          width: 445,\n"
       result += "          height: 390,\n"
       result += "          flashplayer: \"/assets/jwplayer6/jwplayer.flash.swf\",\n" 
       result += "          primary: '"+primary+"',\n"
       result += "          controls: true\n"
       result += "        });\n"
       result += "      </script>\n"

       return result
     end

    def self.show_participants(fedora_obj, datastream="ARCHIVAL_XML")
        result = ""
        participant_number = 0
        node_sets = fedora_obj.datastreams[datastream].find_by_terms(:participants)

        node_sets.each do |node|
          node.children.each do |child|
            unless child.attributes.empty?
              participant_number += 1
              id = child.attributes["id"]
              role = child.attributes["role"]
              sex = child.attributes["sex"].to_s
              result << "        <div class=\"participant_row\" id=\"participant" + participant_number.to_s + "\">\n"
              result << "          <div class=\"participant_id\">" + (id.nil? ? "" : id) + "</div>\n"
              result << "          <div class=\"participant_name\">" + child.text + "<span class=\"participant_role\">" + (role.nil? ? "" : ", " + role) + (sex.nil? ? "" : " (" + (sex == "f" ? "female" : (sex == "m" ? "male" : sex)) + ")") + "</span></div>\n"
              result << "        </div> <!-- participant_row -->\n"
            end
          end
        end

        if result.length > 0
          result = "<div class=\"participant_table\">\n" + result + "      </div> <!-- participant_table -->\n"
        end

        return result
      end


    # convert fedora transcript object to html
    def self.show_transcript(fedora_obj, active_timestamps, datastream="ARCHIVAL_XML")
      chunks = TranscriptChunk.parse(fedora_obj, datastream)
      html = format_transcript(chunks, active_timestamps, fedora_obj.pid)
      return html
    end

    def self.get_time_table(fedora_obj, datastream="ARCHIVAL_XML")
      chunks = TranscriptChunk.parse(fedora_obj, datastream)
      table = extract_time_table(chunks)
      table
    end

    def self.extract_time_table(chunks)
      table = {}
      chunks.each do |chunk|
          milliseconds = chunk.start_in_milliseconds
          string_minutes, string_just_seconds, string_total_seconds = displayable_time(milliseconds)
          table[chunk.name.to_s] = {:time => milliseconds, :display_time => string_minutes + ":" + string_just_seconds}
      end
      table
    end

    # return html string of the transcript
    # iterate over chunks and create appropriate divs with classes, links, etc.
    def self.format_transcript(chunks, active_timestamps, pid)
      result = "<div class=\"transcript_table\">\n"
      chunks.each do |chunk|
        milliseconds = chunk.start_in_milliseconds
        string_minutes, string_just_seconds, string_total_seconds = displayable_time(milliseconds)
        div_id = chunk.name

        result << "                <div class=\"transcript_chunk\" id=\"chunk" + string_total_seconds + "\">\n"

        unless (milliseconds.nil?)
          result << "                  <div class=\"transcript_row\">\n"
          result << "                    <div class=\"transcript_speaker\">\n"
          #https://corpora.tufts.edu/catalog/tufts:MS025.006.008.00004.00003?timestamp/0:00
          if (active_timestamps)
            result << "                      <a class=\"transcript_chunk_link\" data-time=\"" + milliseconds.to_s + "\" href=\"/catalog/"+ pid + "?timestamp/" + string_minutes + ":" + string_just_seconds + "\">" + string_minutes + ":" + string_just_seconds + "</a>\n"
          else
            result << "                      <span class=\"transcript_chunk_link\">" + string_minutes + ":" + string_just_seconds + "</span>\n"
          end

          result << "                    </div> <!-- transcript_speaker -->\n"
          result << "                    <div class=\"transcript_utterance\"></div>\n"
          result << "                  </div> <!-- transcript_row -->\n"
        end
        utterances = chunk.utterances
        utterances.each do |utterance|
          who = utterance.speaker_initials
          text = utterance.text
          timepoint_id = utterance.timepoint_id
          if (who)
            result << "                  <div class=\"transcript_row\">\n"
            result << "                    <div class=\"transcript_speaker\">"+ (who.nil? ? "" : who) + "</div>\n"
            result << "                    <div class=\"transcript_utterance\"  id=\""+timepoint_id+"\">"+ (text.nil? ? "" : text) + "</div>\n"
            result << "                  </div> <!-- transcript_row -->\n"
          else
            unless text.nil?
              result << "                  <div class=\"transcript_row\">\n"
              result << "                    <div class=\"transcript_speaker\">" "</div>\n"
              result << "                    <div class=\"transcript_utterance\" id=\""+ timepoint_id+"\"><span class = \"transcript_notation\">["+ text + "]</span></div>\n"
              result << "                  </div> <!-- transcript_row -->\n"
            end
          end
        end
        result << "                </div> <!-- transcript_chunk -->\n"

      end
      result << "              </div> <!-- transcript_table -->\n"

      return result
    end

    def self.parse_notations(node)
         result = ""

         node.children.each do |child|
           childName = child.name

           if (childName == "text")
             result += child.text
           elsif (childName == "unclear")
             result += "<span class=\"transcript_notation\">[" + child.text + "]</span>"
           elsif (childName == "event" || childName == "gap" || childName == "vocal" || childName == "kinesic")
             unless child.attributes.empty?
               desc = child.attributes["desc"]
               unless desc.nil?
                 result += "<span class=\"transcript_notation\">[" + desc + "]</span>"
               end
             end
           end
         end

         return result
       end

    private # all methods that follow will be made private: not accessible for outside objects

    # convert a transcript time in milliseconds into displayable strings for UI
    def self.displayable_time(milliseconds)
      int_total_seconds = milliseconds.to_i / 1000 # truncated to the second
      int_minutes = int_total_seconds / 60
      int_just_seconds = int_total_seconds - (int_minutes * 60) # the seconds for seconds:minutes (0:00) display
      string_minutes = int_minutes.to_s
      string_just_seconds = int_just_seconds.to_s
      if (int_just_seconds < 10)
        string_just_seconds = "0" + string_just_seconds
      end
      return string_minutes, string_just_seconds, int_total_seconds.to_s
    end


  end
end
