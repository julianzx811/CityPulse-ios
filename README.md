# CityPulse

Real-time weather app for iOS built with clean architecture.

## Features
- Real-time weather with OpenWeather API
- MapKit with automatic day/night style
- Rain and snow overlay animations
- City search
- Canvas animations

## Architecture
MVVM + Repository Pattern

## Architecture Diagram
```mermaid
graph TD
    subgraph View
        DS[DashboardScreen]
        MS[MapScreen]
        WA[WeatherAnimation]
    end
    subgraph ViewModel
        WVM[WeatherViewModel]
        WUS[WeatherUiState]
    end
    subgraph Repository
        WR[WeatherRepository]
    end
    subgraph Data
        API[WeatherAPI]
        WM[WeatherModel]
    end
    View -->|@StateObject| ViewModel
    ViewModel -->|async/await| Repository
    Repository -->|URLSession| Data
    Data -->|REST/JSON| External[OpenWeather API]
```