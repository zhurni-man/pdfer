Pdfupper.controllers :agent do
 
  get :search do
    @results = Agent.search_for("#{params[:search]}", :order => 'name_last asc')
    render 'agent/search'
  end

  get :show, :map => '/agent/:id' do
    @agent = Agent.find(params[:id])
    session['agent_id'] = @agent.id

    @uploads = Upload.where(agent_id: @agent.id).sort({created_at: -1})
    render 'agent/show'
  end

  

end
