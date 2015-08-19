Paperclip.interpolates :style_unless_original do |attachment, style|
  "-#{style}" unless style == :original
end