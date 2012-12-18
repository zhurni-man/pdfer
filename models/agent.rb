class Agent < ActiveRecord::Base
	self.table_name = 'agent'
	belongs_to :company
	scoped_search :on => [:id, :name_first, :name_last], :complete_value => true
end