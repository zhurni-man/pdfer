class Listing < ActiveRecord::Base
	self.table_name = 'listing_main'

	belongs_to :agent

	validates_presence_of :property_name, :message => "can't be empty"
	validates_presence_of :addr_street, :message => "can't be empty"
	validates_presence_of :addr_city, :message => "can't be empty"
	validates_presence_of :addr_state, :message => "can't be empty"
	validates_presence_of :addr_zip, :message => "can't be empty"
	
	#validates_presence_of :addr_city
	#validates_presence_of :addr_state
	#validates_presence_of :addr_zip
	#validates_presence_of :addr_country
	#validates_presence_of :commission

end