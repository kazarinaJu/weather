import UIKit

protocol IWeatherPresenter: AnyObject {
    var view: WeatherVC? { get set }
    
    //Event Handler
    func viewDidLoad()
    func weatherCellSelected(_ indexPath: IndexPath)
    
    //DataSource
    func weatherItemsCount() -> Int
    func getWeatherItem(by indexPath: IndexPath) -> Weather
    func getWeatherItems() -> [Weather]
    func makeRandomWeatherItem()
    func getIndexPath() -> IndexPath
    func getRandomWeatherItem() -> Weather
}

final class WeatherPresenter: IWeatherPresenter {
   
    private var weatherService: IWeatherService
    private var weatherData: [Weather] = []
    private var randomIndex = 0
    
    weak var view: WeatherVC?
    
    init(weatherService: IWeatherService) {
        self.weatherService = weatherService
    }
}

//MARK: - DataSource
extension WeatherPresenter {
    
    func weatherItemsCount() -> Int {
        return weatherData.count
    }
   
    func getWeatherItems() -> [Weather] {
        return weatherData
    }
    
    func makeRandomWeatherItem() {
        guard let randomIndex = weatherData.indices.randomElement() else { return }
        weatherData[randomIndex].selected = true
        self.randomIndex = randomIndex
    }
    
    func getIndexPath() -> IndexPath {
        let indexPath = IndexPath(item: randomIndex, section: 0)
        return indexPath
    }
    
    func getRandomWeatherItem() -> Weather {
        let weather = weatherData[randomIndex]
        return weather
    }
    
    func getWeatherItem(by indexPath: IndexPath) -> Weather {
        let weather = weatherData[indexPath.row]
        return weather
    }
}

//MARK: - Business Logic
extension WeatherPresenter {
    func fetchWeather() {
        weatherData = weatherService.fetchWeather()
        view?.reloadCollectionView()
    }
}

//MARK: - Event Handler
extension WeatherPresenter {
    
    func viewDidLoad() {
        fetchWeather()
    }
    
    func weatherCellSelected(_ indexPath: IndexPath) {
        for (index, _) in weatherData.enumerated() {
            weatherData[index].selected = (index == indexPath.row)
        }
        view?.reloadCollectionView()
    }
}
