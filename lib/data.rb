require 'sqlite3'
require 'activerecord'

class Recreation
  module Data

    File.mkdir File.join(File.dirname(__FILE__), '..', 'db') rescue nil
    DBFile   = File.join(File.dirname(__FILE__), '..', 'db', 'db.sqlite')
    Logfile  = File.join(File.dirname(__FILE__), '..', 'db', 'db.log')
    # SETUP
    SQLite3::Database.new DBFile

    ActiveRecord::Base.establish_connection(
      :adapter  => "sqlite3",
      :database => DBFile
    )

    ActiveRecord::Base.logger = Logger.new File.open(Logfile, File::WRONLY | File::APPEND | File::CREAT)

    def self.start_over
      puts 'STARTING OVER'
      File.open(DBFile, 'w') {|f| f.write '' }
    end
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), 'from_xml'))
