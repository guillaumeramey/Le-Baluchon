import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var citiesDescription: [UILabel]!
    @IBOutlet var citiesTemperature: [UILabel]!
    @IBOutlet var citiesWeatherImage: [UIImageView]!

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        updateWeather()
    }

    func updateWeather() {

        for (index, element) in citiesDescription.enumerated() {
            element.text = cities[index].name + " (Mise à jour...)"
        }

        for city in citiesTemperature {
            city.text = "--"
        }
        
        WeatherService.shared.getWeather { (success, weather) in
            if success, let weather = weather {

                for (index, element) in cities.enumerated() {
                    element.date = weather.query.results.channel[index].item.condition.dateFormatted
                    element.temperature = weather.query.results.channel[index].item.condition.temp + "°"
                    element.code = weather.query.results.channel[index].item.condition.code
                }

                for (index, element) in self.citiesTemperature.enumerated() {
                    element.text = cities[index].temperature
                }

                for (index, element) in self.citiesWeatherImage.enumerated() {
                    element.image = cities[index].weatherImage
                }

                for (index, element) in self.citiesDescription.enumerated() {
                    element.text = cities[index].name + " " + cities[index].displayDate
                }

            } else {
                for (index, element) in self.citiesDescription.enumerated() {
                    element.text = cities[index].name + " (Problème de connexion)"
                }
            }
        }
    }

    // MARK: - Actions
    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateWeather()
    }

    // MARK: - White status bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
