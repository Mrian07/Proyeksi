#-- encoding: UTF-8



module Exports
  class Result
    attr_accessor :format,
                  :title,
                  :content,
                  :mime_type

    def initialize(format:, title:, mime_type:, content: nil)
      self.format = format
      self.title = title
      self.content = content
      self.mime_type = mime_type
    end
  end
end
