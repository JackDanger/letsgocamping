class Search
  def self.each
    [new]
  end

  include Leviticus::Page

  locals :title => "Search all recreational locations in the whole U.S."

  write_to do |page|
    '/search.html'
  end
end
