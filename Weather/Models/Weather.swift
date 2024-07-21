

enum WeatherType: String {
    case rain
    case snow
    case sun
    case cloud
    case wind
    case fog
    case storm
}

struct Weather {
    let id: UInt
    let type: WeatherType
    let name: String
    let image: String
    var selected: Bool = false
}


