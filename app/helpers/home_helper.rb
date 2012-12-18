# Helper methods defined here can be accessed in any controller or view in the application

Pdfupper.helpers do
  # def simple_helper_method
  #  ...
  # end
  def current_agent
  	@current_agent ||= session['agent_id'] && Agent.find_by_id(session['agent_id'])
  end

  def current_upload
    @current_upload ||= session['upload_id'] && Upload.find(session['upload_id'])
  end

  def agent_name(id)
  	agent = Agent.find(id)
  	return agent.name_first + " " + agent.name_last
  end

  def format_time(t)
    t.strftime("%F")
  end
end
