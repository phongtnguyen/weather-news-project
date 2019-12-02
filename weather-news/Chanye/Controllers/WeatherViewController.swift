//
//  WeatherViewController.swift
//  weather-news
//
//  Created by Chanye Jung on 11/30/19.
//  Copyright © 2019 Chanye Jung. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation
import SwiftyGif
import RxSwift
import RxCocoa
import RxAlamofire
import ViewAnimator

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherView: UIImageView!
    @IBOutlet weak var weatherWeekTable: UITableView!
    @IBOutlet weak var hourlySlider: UISlider!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    
    let urlFormat1 = "https://api.darksky.net/forecast/62ae1530a99865090bbb88b6de680476/%@,%@"
    let disposeBag = DisposeBag()
    
    var weekWeather = [Weather]()
    var hourWeather = [Weather]()
    var userLatitude: Double = 0
    var userLongitude: Double = 0
    var timer: Timer? = nil
    
    var flag: Int = 0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userLocationSetup()
        sliderSetup()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "day")!)
    }
    
    //MARK: - HOURLY WEATHER SLIDER CHANGER
    
    func sliderSetup(){
        hourlySlider.setValue(0, animated: true)
        hourlySlider.minimumValue = 0
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let roundedValue = Int(round(hourlySlider.value))
        
        debounce(seconds: 0.2) {
            self.changeHourlyView(value: roundedValue)
        }
    }
    
    func debounce(seconds: TimeInterval, function: @escaping () -> Swift.Void ) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            function()
        })
    }
    
    func changeHourlyView(value: Int){
        let summary = hourWeather[value].summary
        self.dateLabel.text = hourWeather[value].date
        self.descriptionLabel.text = hourWeather[value].summary
        self.temperatureLabel.text = "\(Int(hourWeather[value].currentWeather))°F"
        self.timeLabel.text = hourWeather[value].time
        self.humidityLabel.text = "humidity: \(hourWeather[value].humidty)"
        self.windspeedLabel.text = "wind speed: \(hourWeather[value].windSpeed)"
        self.precipLabel.text = "precipitation: \(Int(self.hourWeather[0].precipProbability * 100))%"
        
        let zoomAnimation = AnimationType.zoom(scale: 0.1)
        self.descriptionLabel.animate(animations: [zoomAnimation], duration: 1)
        self.temperatureLabel.animate(animations: [zoomAnimation], duration: 1.5)
        self.humidityLabel.animate(animations: [zoomAnimation], duration: 0.6)
        self.windspeedLabel.animate(animations: [zoomAnimation], duration: 1)
        self.precipLabel.animate(animations: [zoomAnimation], duration: 1.4)
        
        pickWeatherToAnimate(summary: summary)
    }
    
    func pickWeatherToAnimate(summary: String){
        if summary.lowercased().contains("cloudy") || summary.lowercased().contains("overcast"){
            animateWeather(weatherStr: "cloud.gif")
        }
        else if summary.lowercased().contains("foggy"){
            animateWeather(weatherStr: "fog.gif")
        }
        else if summary.lowercased().contains("clear"){
            animateWeather(weatherStr: "stopAnimation")
        }
        else if summary.lowercased().contains("rain") || summary.lowercased().contains("drizzle"){
            animateWeather(weatherStr: "rain.gif")
        }
        else if summary.lowercased().contains("windy") || summary.lowercased().contains("wind"){
        }
        else if summary.lowercased().contains("snow") || summary.lowercased().contains("snow"){
            animateWeather(weatherStr: "snow.gif")
        }
        else{
            animateWeather(weatherStr: "stopAnimation")
        }
    }
    
    func animateWeather(weatherStr: String){
        do {
            let gif = try UIImage(gifName: weatherStr)
            self.weatherView.setGifImage(gif)

        } catch {
            self.weatherView.clear()
        }
    }
}

//MARK: - LOCATION MANAGER
extension WeatherViewController: CLLocationManagerDelegate{
    func userLocationSetup(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLatitude = locValue.latitude
        userLongitude = locValue.longitude
        
        if(flag == 0){
            getWeeklyWeather(latitude: userLatitude, longitude: userLongitude)
            getHourlyWeather(latitude: userLatitude, longitude: userLongitude)
            flag = 1
        }
    }
}

//MARK: - TABLEVIEW
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = weatherWeekTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeeklyWeatherTableViewCell
        
        let summary = weekWeather[indexPath.row].summary
        
        cell.date.text = weekWeather[indexPath.row].date
        cell.lowTemp.text = "\(Int(weekWeather[indexPath.row].temperatureLow))°F"
        cell.highTemp.text = "\(Int(weekWeather[indexPath.row].temperatureHigh))°F"
        
        if summary.lowercased().contains("cloudy") || summary.lowercased().contains("overcast"){
           if #available(iOS 13.0, *) {
            cell.img.image = UIImage(systemName: "cloud")
           }
        }
        else if summary.lowercased().contains("clear"){
           if #available(iOS 13.0, *) {
              cell.img.image = UIImage(systemName: "sun.min")
           }
        }
        else if summary.lowercased().contains("rain") || summary.lowercased().contains("drizzle"){
           if #available(iOS 13.0, *) {
              cell.img.image = UIImage(systemName: "cloud.rain")
           }
        }
        else if summary.lowercased().contains("windy") || summary.lowercased().contains("wind"){
           if #available(iOS 13.0, *) {
              cell.img.image = UIImage(systemName: "wind")
           }
        }
        else if summary.lowercased().contains("snow"){
           if #available(iOS 13.0, *) {
              cell.img.image = UIImage(systemName: "snow")
           }
        }
        else{
           if #available(iOS 13.0, *) {
              cell.img.image = UIImage(systemName: "sun.min")
           }
        }
        
        let upAnimation = AnimationType.from(direction: .bottom, offset: 100.0)
        cell.animate(animations: [upAnimation], duration: 1 + Double((indexPath.row/10)))
            
        return cell
    }
}

class WeeklyWeatherTableViewCell: UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
}

//MARK: - WEATHER MANAGER
extension WeatherViewController{
    func getWeeklyWeather(latitude : Double, longitude : Double){
        userLocationSetup()

        let urlString = String(format: urlFormat1, String(describing: userLatitude),String(describing: userLongitude))
        
        print(urlString)
                
        RxAlamofire.requestJSON(.get, urlString).subscribe(onNext: { (r, json) in
            if let jsonArray = json as? NSDictionary, let jsonDict = jsonArray as? NSDictionary{
                let timezone = jsonDict["timezone"] as! String
                
                let daily = jsonDict["daily"] as! [String:Any]
                let dailyWeather = daily["data"] as! [[String:Any]]
                
                let current = jsonDict["currently"] as! [String:Any]
                let currentWeather = current["temperature"] as! Double
                        
                for day in dailyWeather {
                    let time1 = day["time"] as! Int64
                    let Ndate1 : NSDate = NSDate(timeIntervalSince1970: TimeInterval(time1))
                    let dateFull1 = String(describing: Ndate1).prefix(16)
                    let date1 = dateFull1.prefix(10)
                    let td1 = dateFull1.suffix(6)
                    let summary1 = day["summary"] as! String
                    let tempHigh = day["temperatureHigh"] as! Double
                    let tempLow = day["temperatureLow"] as! Double
                    
                    self.weekWeather.append(Weather(currentWeather: currentWeather, timezone: timezone, date: String(date1), time: String(td1), summary: summary1, temperatureHigh: tempHigh, temperatureLow: tempLow, humidty: 0, windSpeed: 0, precipProbability: 0))
                }
        }
        }, onError: { (error) in
            print(error)
            return
        }, onCompleted: {
            self.locationLabel.text = self.weekWeather[0].timezone
            self.dateLabel.text = self.weekWeather[0].date
            self.descriptionLabel.text = self.weekWeather[0].summary
            self.temperatureLabel.text = "\(Int(self.weekWeather[0].currentWeather))°F"
            self.weatherWeekTable.reloadData()
            self.pickWeatherToAnimate(summary: self.weekWeather[0].summary)
            
            let zoomAnimation = AnimationType.zoom(scale: 0.5)
            self.locationLabel.animate(animations: [zoomAnimation], duration: 0.5)
            self.dateLabel.animate(animations: [zoomAnimation], duration: 0.5)
            self.descriptionLabel.animate(animations: [zoomAnimation], duration: 0.5)
            self.temperatureLabel.animate(animations: [zoomAnimation], duration: 0.5)

        }) {
        }.disposed(by: disposeBag)
    }
    
    func getHourlyWeather(latitude : Double, longitude : Double){
        let urlString = String(format: urlFormat1, String(describing: latitude),String(describing: longitude))
        
        RxAlamofire.requestJSON(.get, urlString).subscribe(onNext: { (r, json) in
            if let jsonArray = json as? NSDictionary, let jsonDict = jsonArray as? NSDictionary{
                let timezone = jsonDict["timezone"] as! String
                
                let hourly = jsonDict["hourly"] as! [String:Any]
                let hourlyWeather = hourly["data"] as! [[String: Any]]
                                
                for hour in hourlyWeather {
                    let currentTemp = hour["temperature"] as! Double
                    let time1 = hour["time"] as! Int64
                    let Ndate1 : NSDate = NSDate(timeIntervalSince1970: TimeInterval(time1))
                    let dateFull1 = String(describing: Ndate1).prefix(16)
                    let date1 = dateFull1.prefix(10)
                    let td1 = dateFull1.suffix(6)
                    let summary1 = hour["summary"] as! String
                    let humidity = hour["humidity"] as! Double
                    let windSpeed = hour["windSpeed"] as! Double
                    let precipProbability = hour["precipIntensity"] as! Double
                    
                    self.hourWeather.append(Weather(currentWeather: currentTemp, timezone: timezone, date: String(date1), time: String(td1), summary: summary1, temperatureHigh: 0, temperatureLow: 0, humidty: humidity, windSpeed: windSpeed, precipProbability: precipProbability))
                }
        }
        }, onError: { (error) in
            print(error)
            return
        }, onCompleted: {
            self.weatherWeekTable.reloadData()
            self.hourlySlider.maximumValue = Float(self.hourWeather.count - 1)
            self.humidityLabel.text = "humidity: \(self.hourWeather[0].humidty)"
            self.windspeedLabel.text = "wind speed: \(self.hourWeather[0].windSpeed)"
            self.precipLabel.text = "precipitation: \(Int(self.hourWeather[0].precipProbability * 100))%"
        }) {
        }.disposed(by: disposeBag)
    }
}
