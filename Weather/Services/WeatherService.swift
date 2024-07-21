import Foundation

protocol IWeatherService {
    func fetchWeather() -> [Weather]
}

struct WeatherService: IWeatherService {
    
    func fetchWeather() -> [Weather] {
        return WeatherService.weatherTypes
    }
    
    static func localizedWeatherName(for type: WeatherType) -> String {
        switch type {
        case .sun:
            return NSLocalizedString("Sunny", comment: "Sunny weather")
        case .rain:
            return NSLocalizedString("Rainy", comment: "Rainy weather")
        case .snow:
            return NSLocalizedString("Snowy", comment: "Snowy weather")
        case .cloud:
            return NSLocalizedString("Cloudy", comment: "Cloudy weather")
        case .wind:
            return NSLocalizedString("Windy", comment: "Windy weather")
        case .fog:
            return NSLocalizedString("Foggy", comment: "Foggy weather")
        case .storm:
            return NSLocalizedString("Stormy", comment: "Stormy weather")
        }
    }
    
    static let weatherTypes: [Weather] = [
        Weather(id: 1, type: .sun, name: localizedWeatherName(for: .sun), image: "sun.max.fill", selected: false),
        Weather(id: 2, type: .rain, name: localizedWeatherName(for: .rain), image: "cloud.rain.fill", selected: false),
        Weather(id: 3, type: .snow, name: localizedWeatherName(for: .snow), image: "cloud.snow.fill", selected: false),
        Weather(id: 4, type: .cloud, name: localizedWeatherName(for: .cloud), image: "cloud.fill", selected: false),
        Weather(id: 5, type: .wind, name: localizedWeatherName(for: .wind), image: "wind", selected: false),
        Weather(id: 6, type: .fog, name: localizedWeatherName(for: .fog), image: "cloud.fog.fill", selected: false),
        Weather(id: 7, type: .storm, name: localizedWeatherName(for: .storm), image: "cloud.bolt.fill", selected: false)
    ]
}
