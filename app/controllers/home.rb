Pdfupper.controllers :home do
 
  get :index, :map => '/' do
    @uploads = Upload.paginate(:page => params[:page], :per_page => 5)
    render 'home/index'
  end

end
