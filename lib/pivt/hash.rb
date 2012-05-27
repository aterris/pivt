class Hash
  def pivt_xml
    xml = ''
    self.each do |key, value|
      if value.is_a?(Hash)
        xml += "<#{key.to_s}>#{value.pivt_xml}</#{key.to_s}>"
      else
        xml += "<#{key.to_s}>#{value.to_s}</#{key.to_s}>"
      end
    end
    xml
  end
end