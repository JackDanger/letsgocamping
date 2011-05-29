require 'sqlite3'
require 'activerecord'

module Recreation
  DBFile  = File.join(File.dirname(__FILE__), '..', 'db', 'db.sqlite')
  Logfile = File.join(File.dirname(__FILE__), '..', 'db', 'db.log')

  module Models

    # SETUP
    SQLite3::Database.new Recreation::DBFile

    ActiveRecord::Base.establish_connection(
      :adapter  => "sqlite3",
      :database => Recreation::DBFile
    )

    ActiveRecord::Base.logger = Logger.new File.open(Recreation::Logfile, File::WRONLY | File::APPEND | File::CREAT)

    def self.start_over
      puts 'STARTING OVER'
      File.open(DBFile, 'w') {|f| f.write '' }
    end
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), 'models', 'from_xml'))

Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), 'models', '*'))).each do |model|
  require model
end

