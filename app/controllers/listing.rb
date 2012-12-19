Pdfupper.controllers :listing do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  get :index do
  end

  get :new do
    @listing = Listing.new
    render 'listing/new'
  end

  get :show, :map => "/listing/:id" do
    @listing = Listing.find(params[:id])
    render 'listing/show'
  end

  post :create do
    @listing = Listing.new(params[:listing])
    @agent = current_agent
    if @listing.save
      @upload = Upload.where(_id: current_upload.id).update(listing_id: @listing.id)
      flash[:notice] = "Listing has been created. An email has been sent to #{@agent.email} to verify."
      redirect url(:listing, :show, :id => @listing.id)
    else
      #flash[:error] = "Error. There was a problem creating a listing."
      #redirect url(:upload, :show, :id => current_upload.id)
      render 'upload/show'
    end
  end

end
