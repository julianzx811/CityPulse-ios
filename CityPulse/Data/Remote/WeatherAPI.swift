import Foundation

actor WeatherAPI {
    
    static let shared = WeatherAPI()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
              !key.isEmpty else {
            fatalError("API_KEY not found")
        }
        return key
    }()
    
    func getWeather(city: String) async throws -> WeatherResponse {
        var components = URLComponents(string: "\(baseURL)/weather")!
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "es")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let decoder = JSONDecoder()
        let response = try await URLSession.shared.data(from: url)
        return try await Task.detached {
            try decoder.decode(WeatherResponse.self, from: response.0)
        }.value
    }
}
