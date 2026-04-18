import Foundation

class WeatherRepository {
    
    private let api = WeatherAPI.shared
    
    func getWeather(city: String) async throws -> WeatherResponse {
        return try await api.getWeather(city: city)
    }
}
