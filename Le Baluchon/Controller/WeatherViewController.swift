import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var tempParis: UILabel!
    @IBOutlet weak var tempNewYork: UILabel!
    @IBOutlet weak var imageParis: UIImageView!
    @IBOutlet weak var imageNewYork: UIImageView!
    @IBOutlet weak var descriptionParis: UILabel!
    @IBOutlet weak var descriptionNewYork: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateWeather()
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateWeather()
    }

    func updateWeather() {
        descriptionParis.text = "PARIS (Mise à jour...)"
        descriptionNewYork.text = "NEW-YORK (Mise à jour...)"
        
        WeatherService.shared.getWeather { (success, weather) in
            if success, let weather = weather {
                self.tempParis.text = weather.getTemperature(for: .paris)
                self.tempNewYork.text = weather.getTemperature(for: .newyork)

                if let data = weather.getWeatherImage(for: .paris) {
                    self.imageParis.image = UIImage(data: data)
                }

                if let data = weather.getWeatherImage(for: .newyork) {
                    self.imageNewYork.image = UIImage(data: data)
                }

                self.descriptionParis.text = "PARIS (le " + weather.getDate(for: .paris) + ")"
                self.descriptionNewYork.text = "NEW-YORK (le " + weather.getDate(for: .newyork) + ")"

            } else {
                self.tempParis.text = "?"
                self.descriptionParis.text = "PARIS (Problème de connexion)"
                self.tempNewYork.text = "?"
                self.descriptionNewYork.text = "NEW-YORK (Problème de connexion)"
            }
        }
    }

    // white status bar functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
