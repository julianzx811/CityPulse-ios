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
