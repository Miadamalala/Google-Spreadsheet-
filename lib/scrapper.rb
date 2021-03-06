require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'google_drive'

#Recupération de l'e-mail d'une mairie du Val d'Oise
def get_townhall_email(townhall_url)
  page = Nokogiri::HTML(URI.open(townhall_url)) 
  email_array = []

  email = page.xpath('//*[contains(text(), "@")]').text
  town = page.xpath('//*[contains(text(), "Adresse mairie de")]').text.split 

  email_array << {town[3] => email} 
  puts email_array
  return email_array
end


#Recupération des URLs de chaque ville du Val d'Oise
def get_townhall_urls
  page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
  url_array = []

  urls = page.xpath('//*[@class="lientxt"]/@href') 

  urls.each do |url| 
    url = "http://annuaire-des-mairies.com/"+ url.text[1..-1] 
    url_array << url
  end
  return url_array
end

#Assemblage des informations 
def town_mail
  res = get_townhall_urls.map do |townhall_url| 
    get_townhall_email(townhall_url)
  end
  return res
end

town_mail

 def initialize
     @arr=[]
     get_townhall_urls.map{|i| @arr << get_townhall_email(i)}
     return @arr
  end

#creation  du fichier.js0n via ruby
def save_as_JSON
    File.open("db/emails.json","w") do |f|
      f.write(@arr.map{|i| Hash[i.each_pair.to_a]}.to_json)
    end
    save_as_JSON
  end 

#spreadsheet renvoie le tableau dans le googledrive 
   def save_as_spreadsheet
    session = GoogleDrive::Session.from_service_account_key("keyconfig.json")
    ws = session.spreadsheet_by_title("spreadsheets").worksheets[0]
    ws[1, 1] = @arr.first.keys[0]
    ws[1, 2] = @arr.first.keys[1]
    @arr.map.with_index{|hash,index|
      ws[index+2, 1] = hash['ville']
      ws[index+2, 2] = hash['email']
    }
    ws.save
  end  
save_as_spreadsheet


#creation du fichier.csv via ruby 
def save_as_csv
  csv = town_mail.flatten.map{ |element| element.map{|k, v| [k, v]}}
  csv = csv.map { |data| data.join(",") }.join("\n")
  File.open("./db/email.csv", 'w') do |file|
    file.write(csv)
  end
end

save_as_csv