# encoding: UTF-8
class Page 
  attr_accessor :content

  def initialize
    @content = ""
  end

  def buf(text)
    content << text.to_s
  end
end
