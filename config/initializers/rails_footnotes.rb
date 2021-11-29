#-- encoding: UTF-8



if defined?(Footnotes) && Rails.env.development?
  Footnotes.run! # first of all
end
