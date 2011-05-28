require File.expand_path(File.join(File.dirname(__FILE__), 'pages', 'index'))
require File.expand_path(File.join(File.dirname(__FILE__), 'pages', 'place'))
require File.expand_path(File.join(File.dirname(__FILE__), 'pages', 'search'))
require File.expand_path(File.join(File.dirname(__FILE__), 'source'))



module Recreation
  extend Leviticus

  index Recreation::Index

  source Recreation::Source

end