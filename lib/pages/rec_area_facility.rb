class RecAreaFacility < ActiveRecord::Base
  extend Recreation::FromXML
  include Leviticus::Page
end