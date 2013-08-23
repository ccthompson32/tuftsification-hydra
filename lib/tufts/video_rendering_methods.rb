module Tufts
  module VideoRenderingMethods
    def self.render_video_path(path, type, pid)
      # no interest in modding the path here but we do want to do it in corpora/sadl
      # so I'm trying to give us a point to override this without bringing the whole
      # controller in to the project
      return path
    end
  end
end