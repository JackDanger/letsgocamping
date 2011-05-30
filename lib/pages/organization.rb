class Organization < ActiveRecord::Base
  extend Recreation::FromXML
  include Leviticus::Page
end