# Helper methods defined here can be accessed in any controller or view in the application

Pdfupper.helpers do
  # def simple_helper_method
  #  ...
  # end
  def unique(filename)
  	count = 0
  	unique_name = filename
  	while File.exists?(unique_name)
  		count += 1
  		unique_name = "#{File.join(
  			File.dirname(filename),
  			File.basename(filename, ".*"))}-#{count}#{File.extname(filename)}"
		end
		unique_name
	end

  def rename_file_extension(source, extension)
    dirname = File.dirname(source)
    basename = File.basename(source, ".*")
    extname = File.extname(source)
    if extname == ""
      if basename[0,1]=="."
        target = dirname + "/." + extension
      else
        target = source + "." + extension
      end
    else
      target = dirname + "/" + basename + "." + extension
    end
    File.rename(source, target)
    target
  end
end
