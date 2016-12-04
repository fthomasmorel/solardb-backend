require_relative 'parser'
require 'parseconfig'
require 'mongo'
require 'date'
require 'json'


config = ParseConfig.new('/var/solardb/etl.conf')
db = Mongo::Client.new(["#{config['DB_HOST']}:#{config['DB_PORT']}"], :database => config['DB_NAME'])

def checkDate(db, date)
    result = db[:weather].find({"date" => date}).to_a
    return false if result.length > 0
    return true
end

if ARGV.length > 0 then

    # file = File.read("/var/solardb/data.json")
    # json = JSON.parse file
    # for record in json do
    #     db[:production].insert_one(record)
    # end

    dateStart = Date.parse("01/01/2015")
    dateEnd = Date.today
    #db[:weather].delete_many({})
    for date in dateStart...dateEnd do
        sunshine = parseSunshineRate(config['MCCITY'], date)
        temperature, humidity, windSpeed, cloudCover, classe = parseWeather(date)
        weather = Weather.new(date, temperature, humidity, windSpeed, cloudCover, sunshine, classe)
        db[:weather].insert_one(weather.to_json)
        db[:weather].find({"date" => date}).update_one('$set' => {'sunshine' => sunshine})
    end
end

while true do
    date = Date.today
    if checkDate(db, date) then
        sunshine = parseSunshineRate(config['MCCITY'], date)
        temperature, humidity, windSpeed, cloudCover, classe = parseWeather(date)
        weather = Weather.new(date, temperature, humidity, windSpeed, cloudCover, sunshine, classe)
        db[:weather].insert_one(weather.to_json)
    end
    sleep 86400
end
