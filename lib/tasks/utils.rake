CUST_FOLDER_NAME = 'custom'
CUST_FOLDERS = ['./config/locales/','./public/documents/','./public/images/', './public/stylesheets/', './app/views/' ].map { |x| x + CUST_FOLDER_NAME }

namespace :utils do
  desc "Un-customize the application."
  task :uncustomize do
    config_folder_path = ENV['config_folder_path']

    # Removal of individual files
    puts "Removal of cdp.rb"
    FileUtils.rm './config/initializers/cdp.rb', :force => true

    # TODO: Don't remove it, replace with dummy file or rake won't work.
    puts "Replace of database.yml with dummy original file"
    FileUtils.cp './config/dummydatabase.yml', './config/database.yml'

    puts "Removal of custom_application_helper"
    FileUtils.rm './lib/custom_application_helper.rb', :force => true

    puts "Removal of custom robots.txt"
    FileUtils.rm './public/robots.txt', :force => true

    # Removal of customize folders
    CUST_FOLDERS.each do |f|
      puts "Removal of #{f}"
      FileUtils.remove_dir f, :force => true
    end
  end

  desc "Configure the application with all the configuration files in the 'customize' directory"
  task :load_customization => [:uncustomize] do
    config_folder_path = ENV['config_folder_path']
    unless config_folder_path
      puts %Q{You should specify the customization folder with something like :
        $ rake utils:load_customization config_folder_path=/home/xxx/myfolder}
    else
      puts "Given configuration folder is : " + config_folder_path
      unless check_configuration_folder(config_folder_path)
        puts "Hmmm... This not looks like a correct customization folder"
      else # configuration folder is ok
        puts "The configuration folder seems ok!"

        # 1. Copy of individual files
        puts "Copy of cdp.rb"
        FileUtils.cp config_folder_path + '/cdp.rb', './config/initializers/'

        puts "Copy of database.yml"
        FileUtils.cp config_folder_path + '/database.yml', './config/'

        puts "Copy of custom_application_helper"
        FileUtils.cp config_folder_path + '/custom_application_helper.rb', './lib'

        # 2. Copy of the custom subfolders
        puts "Copy of the images."
        FileUtils.mkdir_p './public/images/custom'
        FileUtils.cp_r(config_folder_path + '/images/.', './public/images/custom')

        puts "Copy of the documents."
        FileUtils.mkdir_p './public/documents/custom'
        FileUtils.cp_r(config_folder_path + '/documents/.', './public/documents/custom')

        puts "Copy of the css."
        FileUtils.mkdir_p './public/stylesheets/custom'
        FileUtils.cp_r(config_folder_path + '/stylesheets/.', './public/stylesheets/custom')

        puts "Copy of the views."
        FileUtils.mkdir_p './app/views/custom'
        FileUtils.cp_r(config_folder_path + '/views/.', './app/views/custom')

        puts "Copy of the translations."
        FileUtils.mkdir_p './config/locales/custom'
        FileUtils.cp_r(config_folder_path + '/locales/.', './config/locales/custom')

        # 3. Merge of the robots.txt
        puts "Creation of final robots.txt"
        FileUtils.cp './public/robots.txt.base', './public/robots.txt' # Copy the "base" robots.txt to its final name
        # If the custom file exists, append its content
        if FileTest.exist?(config_folder_path + '/robots.txt')
          open('./public/robots.txt', 'a') do |f|
              IO.foreach(config_folder_path+'/robots.txt') {|line| f.puts line }
          end
        end
      end
    end
  end
end

    def check_configuration_folder(folder_path)
      # TODO: Write it !
      # 1) Check presence (and content?) of cdp.rb
      # 2) Check images/bottom.png exists
      true
    end
