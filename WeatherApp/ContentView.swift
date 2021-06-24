//
//  ContentView.swift
//  WeatherApp
//
//  Created by Andrei Zhyunou on 05/05/2021.
//


import SwiftUI
import MapKit

struct ContentView: View {
    
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical) { // Możliwość scrollowania
                
                VStack { // Układanie obiektów w kolumnie
                    ForEach(viewModel.records) {
                        record in WeatherView(record: record, viewModel: viewModel)
                    }
                }.padding()
            }.navigationBarTitle(
                Text("Current Weather")
            )
        }
    }
}


func changePamam(record: WeatherModel.WeatherRecord, caseNumb: Int) -> String {
    
    switch caseNumb {
    case 0:
        return String(format: ("Temperature: %.2f °C"), record.temperature)
    case 1:
        return String(format: ("Humidity: %.2f%%"), record.humidity)
    case 2:
        return String(format: ("Wind speed: %.2f m/s"), record.windSpeed)
    case 3:
        return String(format: ("Wind direction: %.2f°"), record.windDirection)
    default:
        return String(format: ("Temperature: %.2f °C"), record.temperature)
    }
}


struct WeatherView: View {
    @State var idx : Int = 0
    let allCases : Int = 4
    let crnrRadius : CGFloat = 20
    let frHeigh : CGFloat = 80
    let iconWith : CGFloat = 40
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    
    @State private var showingSheet = false
    
    var body: some View {
        ZStack { // Układanie obiektów nad sobą
            RoundedRectangle(cornerRadius: crnrRadius).stroke() // Zostawiamy tylko ramki prostokontu
                .frame(height: frHeigh) // Określamy wysokość
            HStack { // Układanie obiektów w wierszu
                GeometryReader { geometry in // Dopasowanie rozmiaru icony
                    Text(verbatim: viewModel.getWeatherIcon(record: record))
                        .font(.system(size: geometry.size.width))
            }.frame(maxWidth: iconWith) // Maksymalny rozmiar icony
                Spacer() // Dodanie odstępu między iconą a tekstem
                VStack() {
                    Text(record.cityName)
                    Text(changePamam(record: record, caseNumb: idx))
                        .font(.caption)
                }.onTapGesture {
                    if (idx == allCases) {
                        idx = 0
                    }
                    idx += 1
                }
                Spacer() // Dodanie odstępu między tekstem a przyciskiem
                Text("🔄")
                    .font(.largeTitle)
                    .onTapGesture {
                        viewModel.refresh(woeId: record.woeId)
                    }
                

                Button("🗺") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    SheetView(region: getReg(lattlong: record.latt_long))
                }
                NavigationLink(destination:  WeatherDetails(record: record)
                )
                {
                    Text("↗️")
                }
                
            }.padding()
        }
    }
}

func getReg(lattlong : String) -> MKCoordinateRegion {
    let latt_long = lattlong.components(separatedBy: ",")
    return MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: CLLocationDegrees((latt_long[0] as NSString).floatValue),
            longitude: CLLocationDegrees((latt_long[1] as NSString).floatValue)
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 1.0,
            longitudeDelta: 1.0
        )
        )
}

struct SheetView: View {

    @State var region : MKCoordinateRegion
    
    var body: some View {
        Spacer()
        Map(coordinateRegion: $region).padding()
        Spacer()
    }
}

struct WeatherDetails: View {
    var record: WeatherModel.WeatherRecord
    var body: some View {
        Text("\(record.cityName)").font(.title)
        Text("Latitude and longitude: \(record.latt_long)")
        Text("WoeId: \(record.woeId)")
        Text("Temperature: \(record.temperature) °C")
        Text("Humidity: \(record.humidity)%")
        Text("Wind speed: \(record.windSpeed) m/s")
        Text("Wind direction: \(record.windDirection) °")
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
