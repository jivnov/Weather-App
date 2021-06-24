//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Andrei Zhyunou on 05/05/2021.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: WeatherViewModel())
        }
    }
}
