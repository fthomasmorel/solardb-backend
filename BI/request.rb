require 'parseconfig'
require 'mongo'
require 'date'
require 'json/pure'

@@config = ParseConfig.new('/var/solardb/bi.conf')
@@db = Mongo::Client.new(["#{@@config['DB_HOST']}:#{@@config['DB_PORT']}"], :database => @@config['DB_NAME'])

def getAllProduction()
    result = @@db[:production].find().to_a
    result
end

def getAllWeather()
    result = @@db[:weather].find().to_a
    result
end

def recordProduction(production)
    begin
        return false if !production['date'] || !production['production'] || !production['total']
        day = Date.parse(production['date'])
        #return false if date > Date.new()
        prod = getProductionForDay(day)
        if prod then
            @@db[:production].find({"date" => "#{day.strftime("%m")}/#{day.strftime("%d")}/#{day.strftime("%Y")}"}).update_one('$set' => {"production": production['production'], "total": production['total']})
        else
            @@db[:production].insert_one({"date" => "#{day.strftime("%m")}/#{day.strftime("%d")}/#{day.strftime("%Y")}", "production": production['production'], "total": production['total']})
        end
        return true
    rescue
        return false
    end
end

def getProductionForDay(day)
    result = @@db[:production].find({"date" => "#{day.strftime("%m")}/#{day.strftime("%d")}/#{day.strftime("%Y")}"}).to_a
    return result.first if result.length > 0
    return nil
end

def getProductionForMonth(date)
    result = getProductionRecordForMonth(date)
    return {:date => date.strftime("%m/%Y").to_s, :production => 0} if result.length == 0
    return {:date => date.strftime("%m/%Y").to_s, :production => result.last["total"] - result.first["total"]}
end

def getProductionForYear(date)
    results = []
    for month in 1..12 do
        date = Date.parse("01/#{format('%02d', month )}/#{date.strftime("%Y")}")
        production = getProductionForMonth(date)
        results << production
    end
    results
end

def getProductionRecordForMonth(date)
    results = []
    dateStart = Date.parse("01/#{format('%02d', date.strftime("%m").to_i)}/#{date.strftime("%Y")}")
    month_p1 = date.strftime("%m").to_i + 1
    year_p1 = date.strftime("%Y").to_i
    year_p1 += 1 if month_p1 == 13
    month_p1 = 1 if month_p1 == 13
    dateEnd = Date.parse("01/#{format('%02d', month_p1)}/#{year_p1}").prev_day
    for date in ([dateStart, Date.today].min...[dateEnd, Date.today].min) do
        production = getProductionForDay(date)
        results << JSON.parse(production.to_json) if production
    end
    results
end

def getProductionRecordForYear(date)
    results = []
    for month in 1..12 do
        date = Date.parse("01/#{format('%02d', month )}/#{date.strftime("%Y")}")
        production = getProductionRecordForMonth(date)
        results << production
    end
    results
end

def getWeatherForDay(date)
    result = @@db[:weather].find({"date" => date}).to_a
    return result.first if result.length > 0
    return nil
end

def getWeatherForMonth(date)
    results = []
    dateStart = Date.parse("01/#{format('%02d', date.strftime("%m").to_i)}/#{date.strftime("%Y")}")
    month_p1 = date.strftime("%m").to_i + 1
    year_p1 = date.strftime("%Y").to_i
    year_p1 += 1 if month_p1 == 13
    month_p1 = 1 if month_p1 == 13
    dateEnd = Date.parse("01/#{format('%02d', month_p1)}/#{year_p1}").prev_day
    for date in ([dateStart, Date.today].min...[dateEnd, Date.today].min) do
        weather = getWeatherForDay(date)
        results << JSON.parse(weather.to_json) if weather
    end
    results
end

def getWeatherForYear(date)
    results = []
    for month in 1..12 do
        date = Date.parse("01/#{format('%02d', month )}/#{date.strftime("%Y")}")
        weather = getWeatherForMonth(date)
        results << weather
    end
    results
end

def getWeatherCritieraForDay(criteria, date)
    weather = getWeatherForDay(date)
    return weather[criteria] if weather
    return nil
end

def getWeatherCritieraForMonth(criteria, date)
    weathers = getWeatherForMonth(date)
    weathers.map { |weather| weather[criteria] }
end

def getWeatherCritieraForYear(date)
    results = []
    for month in 1..12 do
        date = Date.parse("01/#{format('%02d', month )}/#{date.strftime("%Y")}")
        criteria = getWeatherCritieraForMonth(criteria, date)
        results << criteria
    end
    results
end
