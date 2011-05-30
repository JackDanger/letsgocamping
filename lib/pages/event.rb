class Event < ActiveRecord::Base
  extend Recreation::FromXML
  include Leviticus::Page
end