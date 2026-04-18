import SwiftUI
import Kingfisher

struct DashboardScreen: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var selectedTab = 0
    @State private var showSearch = false
    @State private var searchText = ""
    
    var gradientColors: [Color] {
        guard case .success(let weather) = viewModel.weatherState else {
            return Color.Weather.clearGradient
        }
        switch weather.weather.first?.main.lowercased() {
        case "clear":           return Color.Weather.clearGradient
        case "clouds":          return Color.Weather.cloudsGradient
        case "rain", "drizzle": return Color.Weather.rainGradient
        case "thunderstorm":    return Color.Weather.thunderGradient
        case "snow":            return Color.Weather.snowGradient
        default:                return Color.Weather.clearGradient
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    if showSearch {
                        TextField("Buscar ciudad...", text: $searchText)
                            .textFieldStyle(.plain)
                            .foregroundColor(Color.UI.textPrimary)
                            .submitLabel(.search)
                            .onSubmit {
                                if !searchText.isEmpty {
                                    viewModel.searchCity(searchText)
                                    showSearch = false
                                    searchText = ""
                                }
                            }
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.UI.divider),
                                alignment: .bottom
                            )
                        
                        Button(action: {
                            showSearch = false
                            searchText = ""
                        }) {
                            Image(systemName: WeatherIcon.close)
                                .foregroundColor(Color.UI.textPrimary)
                                .font(.system(size: 18))
                        }
                    } else {
                        HStack(spacing: 8) {
                            Image(systemName: WeatherIcon.globe)
                                .foregroundColor(Color.UI.textPrimary)
                                .font(.system(size: 20))
                            Text("CityPulse")
                                .foregroundColor(Color.UI.textPrimary)
                                .font(.system(size: 20, weight: .bold))
                        }
                        
                        Spacer()
                        
                        Button(action: { showSearch = true }) {
                            Image(systemName: WeatherIcon.search)
                                .foregroundColor(Color.UI.textPrimary)
                                .font(.system(size: 20))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // Tabs
                HStack {
                    TabButton(
                        icon: WeatherIcon.clima,
                        title: "Clima",
                        isSelected: selectedTab == 0
                    ) { selectedTab = 0 }
                    
                    TabButton(
                        icon: WeatherIcon.map,
                        title: "Mapa",
                        isSelected: selectedTab == 1
                    ) { selectedTab = 1 }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                
                switch viewModel.weatherState {
                case .loading:
                    LoadingView()
                case .error(let message):
                    ErrorView(message: message)
                case .success(let weather):
                    if selectedTab == 0 {
                        WeatherContentView(weather: weather)
                    } else {
                        MapScreen(weather: weather)
                    }
                }
            }
        }
        .onAppear {
            viewModel.getWeather(city: "Medellin")
        }
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .foregroundColor(isSelected ? Color.UI.textPrimary : Color.UI.textMuted)
            .font(.system(size: 15, weight: isSelected ? .bold : .regular))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(isSelected ? Color.UI.cardBackground : Color.clear)
            .cornerRadius(20)
        }
        Spacer()
    }
}

struct LoadingView: View {
    @State private var alpha = 0.3
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: WeatherIcon.globe)
                .font(.system(size: 64))
                .foregroundColor(Color.UI.textPrimary)
            Text("Cargando CityPulse...")
                .foregroundColor(Color.UI.textPrimary.opacity(alpha))
                .font(.system(size: 18, weight: .medium))
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        alpha = 1.0
                    }
                }
            Spacer()
        }
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: WeatherIcon.warning)
                .font(.system(size: 64))
                .foregroundColor(Color.UI.textPrimary)
            Text("Error al cargar el clima")
                .foregroundColor(Color.UI.textPrimary)
                .font(.system(size: 18, weight: .bold))
            Text(message)
                .foregroundColor(Color.UI.textSecondary)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer()
        }
    }
}

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
                
                // Animación
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
                    withAnimation(.easeInOut(duration: 2.5).repeatForever()) {
                        floatOffset = 8
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

struct WeatherCardView: View {
    let icon: String
    let value: String
    let label: String
    @State private var cardFloat: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(Color.UI.textPrimary)
            Text(value)
                .foregroundColor(Color.UI.textPrimary)
                .font(.system(size: 18, weight: .bold))
            Text(label)
                .foregroundColor(Color.UI.textSecondary)
                .font(.system(size: 12))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.UI.cardBackground)
        .cornerRadius(20)
        .offset(y: cardFloat)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                cardFloat = 6
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
