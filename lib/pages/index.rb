class Index
  def self.each
    [new]
  end

  include Leviticus::Page

  locals :title => "Let's go Camping!"

  write_to do |page|
    '/index.html'
  end

  def prepare
  end

end
