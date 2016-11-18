require "json"
require "date"

class Weather
    def initialize(date, temperature, classe)
        @date = Date.today
        @temperature = temperature
        @classe = classe
    end

    def date
        @date
    end

    def temperature
        @temperature
    end

    def classe
        @classe
    end

    def to_json
        {:date => @date, :temperature => @temperature, :classe => @classe}
    end
end

def parseWeather(yhCityId)
    begin
        response = `curl "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%#{yhCityId}&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" 2> /dev/null`
        json = JSON.parse response
        results = json["query"]["results"]["channel"]["item"]["condition"]
        date = results["date"]
        temperature = results["temp"]
        classe = results["text"]
        return Weather.new(date, temperature, classe)
    rescue
        return nil
    end
end

def parseSunshineRate(mcCityId, day, month, year)
    begin
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

def parseAirQuality(aqCity)
    begin
        response = `curl "http://aqicn.org/city/france/bretagne/#{aqCity}/serv.-tech./fr/" 2> /dev/null`
        response = response.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
        response = response.split("aqiwgtvalue").last
        first = 0
        last = 0
        i = 0
        for char in response.split('') do
            last = first = i if char == ">"
            last = i if char == "<"
            break if char == "<"
            i += 1
        end
        return response[first+1..last-1].to_i if first < last
        return -1
    rescue
        return -1
    end
end
