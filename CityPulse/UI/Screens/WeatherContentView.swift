import SwiftUI
import Kingfisher

struct WeatherContentView: View {
    let weather: WeatherResponse
    @State private var floatOffset: CGFloat = -8
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 16)
                
                Text("\(weather.name), \(weather.sys.country)")
                    .foregroundColor(Color.UI.textPrimary.opacity(0.9))
                    .font(.system(size: 22, weight: .medium))
                
                Text(weather.weather.first?.description.capitalized ?? "")
                    .foregroundColor(Color.UI.textSecondary)
                    .font(.system(size: 16))
                    .padding(.top, 4)
                
                ZStack {
                    WeatherAnimationView(weatherMain: weather.weather.first?.main.lowercased() ?? "clear")
                        .frame(width: 200, height: 200)
                        .offset(y: floatOffset)
                    
                    if let icon = weather.weather.first?.icon {
                        KFImage(URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
                            .resizable()
                            .frame(width: 80, height: 80)
                            .offset(x: 60, y: -60)
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 2.5).repeatForever()) {
                            floatOffset = 8
                        }
                    }
                }
                
                Text("\(Int(weather.main.temp))°")
                    .foregroundColor(Color.UI.textPrimary)
                    .font(.system(size: 96, weight: .thin))
                
                Text("Sensación \(Int(weather.main.feelsLike))°")
                    .foregroundColor(Color.UI.textSecondary)
                    .font(.system(size: 16))
                
                Spacer().frame(height: 32)
                
                HStack(spacing: 12) {
                    WeatherCardView(icon: WeatherIcon.humidity, value: "\(weather.main.humidity)%", label: "Humedad")
                    WeatherCardView(icon: WeatherIcon.wind, value: "\(Int(weather.wind.speed)) m/s", label: "Viento")
                    WeatherCardView(icon: WeatherIcon.pressure, value: "\(weather.main.pressure) hPa", label: "Presión")
                }
                .padding(.horizontal, 24)
                
                Spacer().frame(height: 16)
            }
        }
    }
}
