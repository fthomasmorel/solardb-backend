require "json"
require "date"

class Weather
    def initialize(date, temperature, humidity, windSpeed, cloudCover, sunshine, classe)
        @date = date
        @temperature = temperature
        @humidity = humidity
        @windSpeed = windSpeed
        @cloudCover = cloudCover
        @sunshine = sunshine
        @classe = classe
    end

    def date
        @date
    end

    def temperature
        @temperature
    end

    def humidity
        @humidity
    end

    def windSpeed
        @windSpeed
    end

    def cloudCover
        @cloudCover
    end

    def sunshine
        @sunshine
    end

    def classe
        @classe
    end

    def to_json
        {
            :date => @date,
            :temperature => @temperature,
            :humidity => @humidity,
            :windSpeed => @windSpeed,
            :cloudCover => @cloudCover,
            :sunshine => @sunshine,
            :classe => @classe
        }
    end
end

def parseWeather(date)
    begin
        year = date.strftime("%Y")
        month = date.strftime("%m")
        day = date.strftime("%d")

        result = `curl "https://api.darksky.net/forecast/3b332215ba74469aa0c8372fe4d9aa6c/47.6947,2.0014,#{year}-#{month}-#{day}T12:00:00" 2> /dev/null`
        json = JSON.parse result
        temperature = json["currently"]["temperature"]
        humidity = json["currently"]["humidity"]
        windSpeed = json["currently"]["windSpeed"]
        cloudCover = json["currently"]["cloudCover"]
        classe = json["currently"]["icon"]

        return temperature, humidity, windSpeed, cloudCover, classe
    rescue
        return nil
    end
end

def parseSunshineRate(mcCityId, date)
    begin
        year = date.strftime("%Y").to_i
        month = date.strftime("%m").to_i
        day = date.strftime("%d").to_i

        response = `curl "http://www.meteociel.fr/temps-reel/obs_villes.php?code2=#{mcCityId}&jour2=#{day}&mois2=#{month-1}&annee2=#{year}" 2> /dev/null`
        response = response.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
        active = false
        for line in response.split("\n") do
            if line.include?(" h</td>") then
                return line.split(" h<\/td>").first.split(">").last.to_f
            else
                active = (line == "<b>Ensoleillement</b>" || line.strip! == "<b>Ensoleillement</b>")
            end
        end
        return -1
    rescue
        return -1
    end
end
#
# def parseAirQuality(aqCity)
#     begin
#         response = `curl "http://aqicn.org/city/france/bretagne/#{aqCity}/serv.-tech./fr/" 2> /dev/null`
#         response = response.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
#         response = response.split("aqiwgtvalue").last
#         first = 0
#         last = 0
#         i = 0
#         for char in response.split('') do
#             last = first = i if char == ">"
#             last = i if char == "<"
#             break if char == "<"
#             i += 1
#         end
#         return response[first+1..last-1].to_i if first < last
#         return -1
#     rescue
#         return -1
#     end
# end
