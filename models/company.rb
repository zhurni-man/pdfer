class Company < ActiveRecord::Base
	self.table_name = 'company'
	has_many :agent
end