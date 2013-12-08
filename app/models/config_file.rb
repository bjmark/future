#encoding=utf-8

class ConfigFile
  def path
    File.join(Rails.root, 'config' , 'future.conf')
  end

  def [](name)
    h[name]
  end

  def h
    return @h if @h  
    
    @h = {}
    content.each do |e|
      k, v = e.split(/\s+/)
      @h[k] = v
    end
    @h
  end

  def content
    File.open(path) do |f|
      lines = []
      while (s = f.gets)
        lines << s.strip if !s.blank?
      end

      lines
    end
  end
end
