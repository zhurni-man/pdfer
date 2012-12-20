Pdfupper.controllers :upload do

  get :index do
    @uploads = Upload.all
  end

  get :show, :map => '/upload/:id' do
    @upload = Upload.find(params[:id])
    @agent = Agent.find(@upload.agent_id)
    session['agent_id'] = @agent.id
    session['upload_id'] = @upload.id
    if @upload.listing_id
      @listing = Listing.find(@upload.listing_id)
    else
      @listing = Listing.new
    end
    if params[:file]
      uploaded_pdf = params[:file].to_s
      if params[:page]
        @uploaded_pdf = uploaded_pdf
      elsif params[:img]
        @extracted_imgs = Dir.glob("/mnt/pdfprocess/#{@agent.id}/images/#{@upload.id}-*.jpg")
      else
        Docsplit.extract_text(uploaded_pdf, :ocr => false, :output => "/mnt/pdfprocess/#{@agent.id}/")
        fileline = File.readlines(uploaded_pdf.gsub(/\.[^.]*$/, ".txt"))
        @s = fileline.reject {|x| x == "\n" || x == "\f" }
      end
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
      user_img_dir = user_dir + "images"
      unless File.exists? File.expand_path(user_img_dir)
        FileUtils.mkdir_p(user_img_dir)
      end
      extname = File.extname(params['myfile'][:filename])
      if extname == ".pdf"
        unique_file = unique(user_dir + params['myfile'][:filename])
        File.open(unique_file, "w") do |f|
          if (f.write(params['myfile'][:tempfile].read))
            uploaded_file = unique_file
            session['current_file'] = unique_file
            upload = Upload.new
            upload[:agent_id] = user
            upload[:fileName] = File.basename(f)
            if upload.save
              value = `pdfimages -j #{uploaded_file} #{user_img_dir}/#{upload.id}`
              #conv = `convert #{upload.id}-*.ppm #{upload.id}
              flash[:notice] = "File uploaded successfully."
              redirect url(:upload, :show, :id => upload.id, :file => uploaded_file)
            else
              flash[:error] = "Error saving uploaded file."
              redirect url(:home, :index)
            end
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
