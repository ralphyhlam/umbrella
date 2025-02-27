require "dotenv/load"
require "http"
require "json"

# location is Classics: 1010 E 59th St Chicago IL 60637

# establish keys
google_key = ENV.fetch("GMAPS_KEY")
pirate_key = ENV.fetch("PIRATE_KEY")

#get https based on address
user_location = gets.chomp
google_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + google_key
raw_google = HTTP.get(google_url)
formatted_google = JSON.parse(raw_google)

#get longitude and latitude based on https
results = formatted_google.fetch("results")
geometry = results[0].fetch("geometry")
location = geometry.fetch("location")

latitude = location.fetch("lat")
longitude = location.fetch("lng")

#get weather https based on lat/lng
pirate_url = "https://api.pirateweather.net/forecast/" + pirate_key + "/" + "#{latitude}, #{longitude}"
raw_pirate = HTTP.get(pirate_url)
formatted_pirate = JSON.parse(raw_pirate)

#get needed info based on https
currently = formatted_pirate.fetch("currently")
current_temperature = currently.fetch("temperature")
pp current_temperature
next_hour = formatted_pirate.fetch("hourly")
next_hour_data = next_hour.fetch("data")
next_hour_point = next_hour_data[0]
next_hour_summary = next_hour_point.fetch("summary")
pp next_hour_summary

#check precipitation loop
#need to retrieve 0-11 of index, then pull data from there
counter = 0
precipitation = next_hour_data[counter]
hour_counter = counter + 1

while counter < 12
    precipitation_point = precipitation.fetch("precipProbability")
    if precipitation_point > 0.1
        pp "The preicipitation probability will be #{precipitation} in #{hour_counter} hour(s)"
        pp "You might want to bring an umbrella"
    else
        pp "You probably won't need an umbrella"
    end
    counter = counter + 1
end


#next_hour_data.each do |hour|
   # precipitation = hour.fetch("precipProbability")
   # if precipitation > 0.1
    #    counter = counter + 1
    #     pp "The preicipitation probability will be #{precipitation} in #{counter} hour(s)"
    #     pp "You might want to bring an umbrella"
    #else
    #     pp "You probably won't need an umbrella"
    #end
#end

     
