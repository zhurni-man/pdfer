Pdfupper.controllers :upload do
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
    @uploads = Upload.all
  end

  get :show, :map => '/upload/:id' do
    @upload = Upload.find(params[:id])
    @agent = Agent.find(@upload.agent_id)
    session['upload_id'] = @upload.id
    if @upload.listing_id
      @listing = Listing.find(@upload.listing_id)
    else
      @listing = Listing.new
    end
    if params[:file]
      uploaded_pdf = params[:file].to_s
      
      #@img_path = "images/pdfprocess/#{@agent.id}/thumbs/#{File.basename(uploaded_pdf, '.pdf')}_*.jpg"
      if params[:page]
        #Docsplit.extract_images(uploaded_pdf, :size => '1500x', :format => :jpg, :output => "/mnt/pdfprocess/#{@agent.id}/thumbs/")
        #@imgs = Dir.glob("/mnt/pdfprocess/#{@agent.id}/thumbs/#{File.basename(uploaded_pdf, '.pdf')}_*.jpg")
        @uploaded_pdf = uploaded_pdf
      else
        Docsplit.extract_text(uploaded_pdf, :output => "/mnt/pdfprocess/#{@agent.id}/")
        fileline = File.readlines(uploaded_pdf.gsub(/\.[^.]*$/, ".txt"))
        @s = fileline.reject {|x| x == "\n" || x == "\f" }
      end
      #@s.reject{ |e| e.include?("\n")}
      #myfile = File.open(uploaded_pdf.gsub(/\.[^.]*$/, ".txt"))
      #@s.gsub!
      #file_text = rename_file_extension(uploaded_pdf, "txt")
      #@s = "#{file_text}"
      #reader = PDF::Reader.new(uploaded_pdf)
      #count = 1
      #@pdfdata = reader.page(count).text
      #@datalist = []
      #pdfdata.each do |data|
        #@datalist.push(data)
      #end
    end
    render 'upload/show'
  end





  post :upload, :map => '/upload' do
    #mnt_dir = '/mnt/pdfprocess/'
    if !File.exists? File.expand_path(MNT_DIR)
      flash[:error] = "Error: cannot upload file. Directory is unavailable."
      redirect url(:home, :index)
    else
      user = session['agent_id']
      user_dir = MNT_DIR + user.to_s + '/'
      unless File.exists? File.expand_path(user_dir)
        Dir.mkdir(user_dir, 0777)
      end
      #bname = File.basename(unique(params['myfile'][:filename]), ".pdf")
      #file_dir = user_dir + bname + '/'
      extname = File.extname(params['myfile'][:filename])
      #unless File.exists? File.expand_path(file_dir)
      #  Dir.mkdir(file_dir, 0777)
      #end
      if extname == ".pdf"
        unique_file = unique(user_dir + params['myfile'][:filename])
        File.open(unique_file, "w") do |f|
          if (f.write(params['myfile'][:tempfile].read))
            uploaded_file = unique_file
            session['current_file'] = unique_file
            upload = Upload.new
            upload[:agent_id] = user
            upload[:fileName] = File.basename(f)
            upload.save
            flash[:notice] = "File uploaded successfully."
            redirect url(:upload, :show, :id => upload.id, :file => uploaded_file)
          else
            flash[:error] = "Error: There was a problem uploading the file."
            redirect url(:home, :index)
          end
        end
      else
        flash[:error] = "You may upload only .pdf files."
        redirect url(:agent, :show, :id => user)
      end
    end
  end
  
end
