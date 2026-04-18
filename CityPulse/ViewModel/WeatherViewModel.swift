import Foundation
import Combine

enum WeatherUiState {
    case loading
    case success(WeatherResponse)
    case error(String)
}

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var weatherState: WeatherUiState = .loading
    @Published var searchText: String = ""
    
    private let repository = WeatherRepository()
    
    func getWeather(city: String) {
        Task {
            weatherState = .loading
            do {
                let weather = try await repository.getWeather(city: city)
                weatherState = .success(weather)
            } catch {
                weatherState = .error(error.localizedDescription)
            }
        }
    }
    
    func searchCity(_ city: String) {
        getWeather(city: city)
    }
}
