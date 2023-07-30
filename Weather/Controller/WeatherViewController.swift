//
//  ViewController.swift
//  Weather
//
//  Created by Ahmed Alaa on 20/07/2023.
//  

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //MARK: - Outlest.
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Properties.
    var weatherManger = WeatherManager()
    let locationManger = CLLocationManager()
    
    //MARK: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
        
        
        weatherManger.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        locationManger.requestLocation()
        
    }
    
}

//MARK: - extension UITextFieldDelegate.
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManger.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func didUpDateWeather(_ weatherManger: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionNmae)
            self.cityLabel.text = weather.cityNmae
        }
    }
}
//MARK: - extension WeatherMangerDelegate.
extension WeatherViewController: WeatherMangerDelegate {
    func didUpdateWeather(_ weatherManger: WeatherManager, Weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = Weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: Weather.conditionNmae)
            self.cityLabel.text = Weather.cityNmae
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - extension CLLocationManagerDelegate.
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManger.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


