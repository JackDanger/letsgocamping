class RecAreaActivity < ActiveRecord::Base
  extend Recreation::FromXML
  include Leviticus::Page
end