import UIKit

final class WeatherConfigurator {
    func configure() -> WeatherVC {
        
        let weatherService = WeatherService()
        let weatherPresenter =
        WeatherPresenter(weatherService: weatherService)
        
        let weatherView = WeatherVC(presenter: weatherPresenter)
        weatherPresenter.view = weatherView
        
        return weatherView
    }
}
