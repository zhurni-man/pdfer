# Helper methods defined here can be accessed in any controller or view in the application

Pdfupper.helpers do
  # def simple_helper_method
  #  ...
  # end
  def agent_listing_name(id)
  	listing = Listing.find(id)
  	return listing.property_name
  end
end
