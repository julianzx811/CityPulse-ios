import SwiftUI
import MapKit

struct MapScreen: View {
    let weather: WeatherResponse
    
    private var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 6 || hour >= 19
    }
    
    private var isRaining: Bool {
        let main = weather.weather.first?.main.lowercased() ?? ""
        return ["rain", "drizzle", "thunderstorm"].contains(main)
    }
    
    private var isSnowing: Bool {
        let main = weather.weather.first?.main.lowercased() ?? ""
        return main == "snow"
    }
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.2442, longitude: -75.5812),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: [weather]) { _ in
                MapMarker(
                    coordinate: CLLocationCoordinate2D(
                        latitude: weather.coord.lat,
                        longitude: weather.coord.lon
                    ),
                    tint: isRaining ? .blue : .red
                )
            }
            .colorScheme(isNight ? .dark : .light)
            .ignoresSafeArea()
            .onAppear {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: weather.coord.lat,
                        longitude: weather.coord.lon
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            }
            
            if isRaining {
                RainOverlayView()
            }

            if isSnowing {
                SnowOverlayView()
            }
            
            
            // Badge día/noche
            VStack {
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: isNight ? WeatherIcon.moon : WeatherIcon.sun)
                            .foregroundColor(isNight ? Color.Map.nightText : Color.Map.dayText)
                        Text(isNight ? "Noche" : "Día")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(isNight ? Color.Map.nightText : Color.Map.dayText)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isNight ? Color.Map.nightBackground : Color.Map.dayBadge)
                    .cornerRadius(12)
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                Spacer()
            }
            
            // Stats card
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    MapStatView(icon: WeatherIcon.thermometer, value: "\(Int(weather.main.temp))°C", label: "Temp", isNight: isNight)
                    MapStatView(icon: WeatherIcon.humidity, value: "\(weather.main.humidity)%", label: "Humedad", isNight: isNight)
                    MapStatView(icon: WeatherIcon.wind, value: "\(Int(weather.wind.speed)) m/s", label: "Viento", isNight: isNight)
                    MapStatView(icon: WeatherIcon.pressure, value: "\(weather.main.pressure)", label: "Presión", isNight: isNight)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isNight ? Color.Map.nightBackground.opacity(0.9) : Color.white.opacity(0.9))
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

extension WeatherResponse: Identifiable {
    public var id: String { name }
}
