class RecreationalActivity < ActiveRecord::Base
  extend Recreation::FromXML
  include Leviticus::Page
end