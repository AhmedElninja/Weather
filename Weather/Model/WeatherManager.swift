//
//  WeatherManager.swift
//  Weather
//
//  Created by Ahmed Alaa on 20/07/2023.
//

import Foundation
import CoreLocation

protocol WeatherMangerDelegate {
    func didUpDateWeather(_ weatherManger: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let wetherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7f6b6697af7d98eae6055653876c9469&units=metric"
    
    var delegate: WeatherMangerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(wetherURL)&q=\(cityName)"
        performeRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(wetherURL)&lat=\(latitude)&lon=\(longitude)"
        performeRequest(with: urlString)
    }
    
    func performeRequest(with urlString: String) {
        //1.Create a URL
        
        if let url = URL(string: urlString) {
            
            //2.Create a urlSession
            
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parsJson(safeData) {
                        self.delegate?.didUpDateWeather(self, weather: weather)
                    }
                }
            }
            
            //4.start the task
            task.resume()
            
        }
    }
    
    func parsJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityNmae: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}



