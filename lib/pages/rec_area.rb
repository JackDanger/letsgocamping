class RecArea < ActiveRecord::Base
  extend Recreation::FromXML
  include Leviticus::Page
end