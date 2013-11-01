require 'eat_importer'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'open-uri'

namespace :import do
  namespace :eat do

    desc "run all the tasks for the import:eat namespace"
    task :all => [:judgments, :js1, :js2, :judgment_jurisdiction]

    desc "import EAT judgments"
    task :judgments => :environment do
      EATImporter.new('data/eat').import_judgments
    end

    desc "import EAT jurisdiction_level1"
    task :js1 => :environment do
      EATImporter.new('data/eat').import_js1
    end

    desc "import EAT jurisdiction_level2"
    task :js2 => :environment do
      EATImporter.new('data/eat').import_js2
    end

    desc "import EAT judment_jurisdictions"
    task :judgment_jurisdiction => :environment do
      EATImporter.new('data/eat').import_category_decision
    end

    task :process_docs => [:environment] do
      EatDecision.find_each do |d|
        puts "Processing docs for EatDecision id #{d.id}"
        d.add_doc
        d.process_doc
      end
    end

    def query_head(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Head.new(uri.request_uri)
      response = http.request(request)
    end

    def pdf_version(path)
      URI.parse(path.gsub(/doc$/, "pdf"))
    end

    def download_doc(path,id)
      extension = path.split('/').last.split('.').last

      File.open("#{Rails.root}/data/eat/downloads/#{id}.#{extension}", "wb") do |file|
        file.write open(path).read
      end
    end


    desc "check if the decision docs are available"
    task :check_docs => :environment do
      url = 'http://www.employmentappeals.gov.uk'
      broken_count = 0

      EatDecision.find_each do |d|
        file = d.filename.gsub(/\s/, '')
        path = "#{url}/Public/Upload/#{file}"
        uri = URI.parse path

        response = query_head(uri)

        if response.code.to_i == 200
          download_doc path, d.id
        else
          puts "Can't download #{d.id}, #{d.filename}"
          puts "Checking if I can download it as a PDF"
          path = "#{url}/Public/Upload/#{file}"
          uri = pdf_version path

          response = query_head(uri)

          if response.code.to_i == 200
            puts "PDF version can be downloaded"
            download_doc path, id
          else
            puts "PDF version can't be downloaded, trying webscrape"
            doc = Nokogiri::HTML(open "http://#{uri.host}/Public/results.aspx?id=#{d.id}")

            doc.xpath('//*[@id="rpResults__ctl1_lnkView"]/@href').each do |l|
              puts "link is : #{l}"
              path = "#{url}/Public/#{l}"
              uri = URI.parse path

              response = query_head(uri)

              if response.code.to_i == 200
                puts "Webscrape worked, dow"
                download_doc path, d.id
              else
                puts "Webscrape for #{d.id}, #{file} still failed..."
                broken_count += 1
              end
            end
          end
        end
      end

      puts "Total broken count is: #{broken_count}"
    end

  end
end
