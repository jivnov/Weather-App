//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Andrei Zhyunou on 05/05/2021.
//

import Foundation
import Combine

import CoreLocation
import MapKit


class WeatherViewModel: ObservableObject {


    private let woeIds: Array = ["523920", "44418", "615702", "565346", "834463", "2122265", "368148", "727232", "721943", "638242"]


    private let fetcher: MetaWeatherFetcher
    @Published private(set) var model: WeatherModel

    private var cancellables: Set<AnyCancellable> = []


    init() {
        fetcher = MetaWeatherFetcher()
        model = WeatherModel()
        for woeId in woeIds {
            Just(woeId)
                .sink ( receiveValue: fetchWeather(forId:))
                .store(in: &cancellables)
        }
    }

    func fetchWeather(forId woeId: String) {
        fetcher.forecast(forId: woeId)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { value in
                self.model.records.append(WeatherModel.WeatherRecord(response: value))
            })
            .store(in: &cancellables)
    }


    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }

    func refresh(woeId: String) {
        objectWillChange.send()
        fetcher.forecast(forId: woeId)
            .receive(on: RunLoop.main)
            .map { value in
                WeatherModel.WeatherRecord(response: value)
            }
            .sink(receiveCompletion: { completion in
            }, receiveValue: { value in
                self.model.refresh(woeId: woeId, newValue: value)
            })
            .store(in: &cancellables)
    }


    func getWeatherIcon(record: WeatherModel.WeatherRecord) -> String {
        switch record.weatherState {
        case WeatherModel.WeatherCases.Snow:
            return "🌨"
        case WeatherModel.WeatherCases.Thunderstorm:
            return "🌩"
        case WeatherModel.WeatherCases.HeavyRain:
            return "🌧"
        case WeatherModel.WeatherCases.LightRain:
            return "🌧"
        case WeatherModel.WeatherCases.Showers:
            return "🌦"
        case WeatherModel.WeatherCases.HeavyCloud:
            return "☁️"
        case WeatherModel.WeatherCases.LightCloud:
            return "🌤"
        default:
            return "☀️"
        }
    }
}
