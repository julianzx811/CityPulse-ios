import SwiftUI

extension Color {
    struct Weather {
        // Gradientes
        static let clearGradient = [
            Color("ColorClear1"),
            Color("ColorClear2"),
            Color("ColorClear3")
        ]
        static let cloudsGradient = [
            Color("ColorClouds1"),
            Color("ColorClouds2"),
            Color("ColorClouds3")
        ]
        static let rainGradient = [
            Color("ColorRain1"),
            Color("ColorRain2"),
            Color("ColorRain3")
        ]
        static let thunderGradient = [
            Color("ColorThunder1"),
            Color("ColorThunder2"),
            Color("ColorThunder3")
        ]
        static let snowGradient = [
            Color("ColorSnow1"),
            Color("ColorSnow2"),
            Color("ColorSnow3")
        ]
    }
    
    struct Map {
        static let nightBackground = Color("NightBackground")
        static let dayBadge = Color("DayBadge")
        static let nightText = Color("NightText")
        static let dayText = Color("DayText")
    }
    
    struct UI {
        static let cardBackground = Color.white.opacity(0.15)
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.7)
        static let textMuted = Color.white.opacity(0.5)
        static let divider = Color.white.opacity(0.5)
    }
}

enum WeatherIcon {
    static let search = "magnifyingglass"
    static let close = "xmark"
    static let globe = "globe.americas.fill"
    static let warning = "exclamationmark.triangle.fill"
    static let humidity = "humidity.fill"
    static let wind = "wind"
    static let pressure = "gauge.medium"
    static let thermometer = "thermometer.medium"
    static let moon = "moon.fill"
    static let sun = "sun.max.fill"
    static let clima = "cloud.sun.fill"
    static let map = "map.fill"
}
