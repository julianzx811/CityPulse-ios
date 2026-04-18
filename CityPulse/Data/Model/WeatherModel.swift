import Foundation

struct WeatherResponse: Codable, Sendable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let sys: Sys
    let coord: Coord
}
ß
struct Main: Codable, Sendable {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    let pressure: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
        case pressure
    }
}

struct Weather: Codable, Sendable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable, Sendable {
    let speed: Double
    let deg: Int
}

struct Sys: Codable, Sendable {
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Coord: Codable, Sendable {
    let lat: Double
    let lon: Double
}
