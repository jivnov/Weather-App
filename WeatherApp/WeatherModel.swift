//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Andrei Zhyunou on 05/05/2021.
//

import Foundation


struct WeatherModel {
    
    var records = Array<WeatherRecord>()
    
    enum WeatherCases: String, CaseIterable {
        case Snow = "Snow"
        case Thunderstorm = "Thunderstorm"
        case LightRain = "LightRain"
        case HeavyRain = "Heavy Rain"
        case Showers = "Showers"
        case HeavyCloud = "Heavy Cloud"
        case LightCloud = "Light Cloud"
        case Clear = "Clear"
    }
        
    
    struct WeatherRecord: Identifiable, Equatable {
        
        var id: UUID = UUID()
        var cityName: String
        var weatherState: WeatherCases
        var temperature: Float
        var humidity: Float
        var windSpeed: Float
        var windDirection:Float
        var woeId: String
        var latt_long: String
        
        
        init(response: MetaWeatherResponse){
            cityName = response.title
            latt_long = response.lattLong
            woeId = String(response.woeid)
            weatherState = WeatherModel.WeatherCases(rawValue: response.consolidatedWeather[0].weatherStateName) ?? WeatherCases.Clear
            temperature = Float(response.consolidatedWeather[0].theTemp)
            humidity = Float(response.consolidatedWeather[0].humidity)
            windSpeed = Float(response.consolidatedWeather[0].windSpeed)
            windDirection = Float(response.consolidatedWeather[0].windDirection)
        }
    }
    
    mutating func refresh(woeId: String, newValue: WeatherRecord) {
        if let ind = records.firstIndex(where: { $0.woeId == woeId }) {
            records[ind] = newValue
        }
    }
    
}
