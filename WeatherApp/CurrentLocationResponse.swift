//
//  CurrentLocationResponse.swift
//  WeatherApp
//
//  Created by Andrei Zhyunou on 07/06/2021.
//

import Foundation

// MARK: - MetaWeatherLocationResponseElement
struct MetaWeatherLocationResponseElement: Codable {
    let distance: Int
    let title: String
    let locationType: LocationType
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case distance, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

enum LocationType: String, Codable {
    case city = "City"
}

typealias MetaWeatherLocationResponse = [MetaWeatherLocationResponseElement]
