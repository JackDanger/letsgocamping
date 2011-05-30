class RecAreaAddress < ActiveRecord::Base
  extend Recreation::FromXML
  include Leviticus::Page
end