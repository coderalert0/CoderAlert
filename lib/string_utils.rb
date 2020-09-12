class String
  def snakify
    gsub(/\W/, '_').underscore
  end
end
