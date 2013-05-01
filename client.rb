require "httparty"
require 'httmultiparty'
require 'optparse'
require 'yaml'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: client.rb [options]"
  opts.on('-l', '--list a,b,c', Array, "List of parameters" ) { |v| options[:files] = v }
  opts.on('-h', '--ipaddress IP', 'IP Address') { |v| options[:ip_address] = v }
  opts.on('-d', '--directory DIRECTORY', 'Directory') { |v| options[:directory] = v }
end.parse!

if options[:ip_address].nil?
    puts "Please, could you provide the IP address to the form."
else
  directory = options[:directory].gsub("\\", "/")

  if options[:files].nil? && !directory.nil?
    options[:files] = Array.new
    puts "Upload from folder #{directory}"
    if Dir.exists?(directory)
      dir = Dir.glob(File.join(directory, '**/*.{mp4,srt,avi}'))
      dir.each {
        |f|
        puts "Upload #{f}? (Y/N)"
        response = gets.chomp
        if response.downcase == "yes" || response.downcase == "y"
          options[:files] << f
          puts "File #{f} added in the list of #{options[:files].size} element(s)."
        end
      }
    end
  end 

  files = options[:files]
  if files.nil?
    puts "Please, could you provide the files to upload."
  else
    puts "Ruby script should upload #{files.size} file(s)."
    url = "http://#{options[:ip_address]}:8080/uploadFile.html"
    beginning = Time.now
    uploading = 0
    for file in files
      beginning_loop = Time.now
      uploading += 1
      if File.exists?(file)
        sizeInBytes = File.size(file)
        sizeInMegaBytes = sizeInBytes / 2**20
        puts "Uploading (#{uploading}/#{files.size}) #{file} (#{sizeInMegaBytes.round(2)}MB)"
        
        response = HTTMultiParty.post(url, :query => {
          :upfile => File.new(file)
        })

        time = Time.now - beginning_loop
        sizeInKiloBytes = sizeInBytes / 2**10
        speed = (sizeInKiloBytes / time)
        puts "#{file} uploaded in #{time.round(2)} seconds at #{speed.round(2)}KB/s"
        sleep 3
      else
        puts "The file #{file} does not exist."
      end
    end

    puts "#{files.size} file(s) uploaded in #{(Time.now - beginning).round(2)} seconds."
  end
end