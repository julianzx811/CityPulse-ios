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

// MARK: - Map Stat
struct MapStatView: View {
    let icon: String
    let value: String
    let label: String
    let isNight: Bool
    
    var textColor: Color {
        isNight ? Color.Map.nightText : Color.Map.dayText
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(textColor)
            Text(value)
                .foregroundColor(textColor)
                .font(.system(size: 14, weight: .bold))
            Text(label)
                .foregroundColor(textColor.opacity(0.6))
                .font(.system(size: 11))
        }
        .frame(maxWidth: .infinity)
    }
}

struct RainOverlayView: View {
    @State private var rainOffset = 0.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let offset = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.0)
                
                let drops: [(CGFloat, CGFloat, CGFloat)] = (0..<80).map { i in
                    let seed = Double(i) * 1.618
                    let x = CGFloat((seed * 13.7).truncatingRemainder(dividingBy: 100.0)) / 100.0
                    let startY = CGFloat((seed * 7.3).truncatingRemainder(dividingBy: 100.0)) / 100.0
                    let speed = CGFloat(0.5 + (seed * 3.1).truncatingRemainder(dividingBy: 0.8))
                    return (x, startY, speed)
                }
                
                for (x, startY, speed) in drops {
                    let y = (startY + CGFloat(offset) * speed).truncatingRemainder(dividingBy: 1.0)
                    let alpha = Double(0.3 + speed * 0.3)
                    var drop = Path()
                    drop.move(to: CGPoint(x: size.width * x, y: size.height * y))
                    drop.addLine(to: CGPoint(x: size.width * x - 2, y: size.height * y + 18))
                    context.stroke(drop, with: .color(.blue.opacity(alpha)), lineWidth: 2)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct SnowOverlayView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let offset = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 3.0) / 3.0
                
                let flakes: [(CGFloat, CGFloat)] = (0..<60).map { i in
                    let seed = Double(i) * 1.618
                    let x = CGFloat((seed * 9.3).truncatingRemainder(dividingBy: 100.0)) / 100.0
                    let startY = CGFloat((seed * 5.7).truncatingRemainder(dividingBy: 100.0)) / 100.0
                    return (x, startY)
                }
                
                for (x, startY) in flakes {
                    let y = (startY + CGFloat(offset)).truncatingRemainder(dividingBy: 1.0)
                    let flakeY = size.height * y
                    let alpha = Double(0.5 + (1.0 - y) * 0.5)
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: size.width * x - 4,
                            y: flakeY - 4,
                            width: 8,
                            height: 8
                        )),
                        with: .color(.white.opacity(alpha))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

extension WeatherResponse: Identifiable {
    public var id: String { name }
}
