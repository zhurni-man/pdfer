Pdfupper.controllers :listing do

  get :index do
  end

  get :show, :map => "/listing/:id" do
    @listing = Listing.find(params[:id])
    render 'listing/show'
  end

  get :new do
    @listing = Listing.new
    render 'listing/new'
  end

  post :create do
    @listing = Listing.new(params[:listing])
    @agent = current_agent
    if @listing.save
      @upload = Upload.where(_id: current_upload.id).update(listing_id: @listing.id)
      case settings.environment
      when :development
        body = render 'listing/mail', :layout => false
        options = {
          :to => 'jsagisi@propertyline.com',
          :from => 'tech@propertyline.com',
          :subject => "Listing Created: #{@listing.id}",
          :body => 'Test text',
          :html_body => body,
          :via => :smtp,
          :via_options => {
            :address      => 'mail.propertyline.com',
            :port         => '25',
            :domain       => "localhost"
          }
        }
      when :production
        body = render 'listing/mail', :layout => false
        options = {
          :to => @agent.email,
          :from => 'tech@propertyline.com',
          :subject => "Listing Created: #{@listing.id}",
          :body => 'Test text',
          :html_body => body,
          :via => :smtp,
          :via_options => {
            :address      => 'mail.propertyline.com',
            :port         => '25',
            :domain       => "localhost"
          }
        }
      end
      Pony.mail(options)
      flash[:notice] = "Listing has been created. An email has been sent to #{@agent.email} to verify."
      redirect url(:listing, :show, :id => @listing.id)
    else
      #flash[:error] = "Error. There was a problem creating a listing."
      #redirect url(:upload, :show, :id => current_upload.id)
      render 'upload/show'
    end
  end

  get :edit, :with => :id do
    @listing = Listing.find(params[:id])
    render 'listing/edit'
  end

  put :update, :map => "/listing/:id" do
    @listing = Listing.find(params[:id])
    if @listing.update_attributes(params[:listing])
      flash[:notice] = "Listing has been updated."
      redirect url(:listing, :show, :id => @listing.id)
    else
      flash[:error] = "There was an error updating."
      render 'upload/show'
    end
  end
end
