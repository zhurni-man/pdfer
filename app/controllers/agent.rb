Pdfupper.controllers :agent do
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
  get :search do
    @results = Agent.search_for("#{params[:search]}", :order => 'name_last asc')
    render 'agent/search'
  end

  get :show, :map => '/agent/:id' do
    @agent = Agent.find(params[:id])
    session['agent_id'] = @agent.id

    @uploads = Upload.where(agent_id: @agent.id).sort({created_at: -1})
    #@listings = Listing.find(:all, :conditions => [ "agent_id = ?", @agent.id], :limit => 5)
    render 'agent/show'
  end

  

end
