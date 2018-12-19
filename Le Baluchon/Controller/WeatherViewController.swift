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

    func updateWeather() {
        WeatherService().getWeather(for: .paris, callback: { (success, weather) in
            if success, let weather = weather {
                self.tempParis.text = weather.temperature

                if let data = weather.getImage(forCode: weather.code) {
                    self.imageParis.image = UIImage(data: data)
                }

                self.descriptionParis.text = "PARIS (le " + weather.date + ")"

            } else {
                self.tempParis.text = "?"
                self.descriptionParis.text = "PARIS (Problème de connexion)"
            }
        })

        WeatherService().getWeather(for: .newyork, callback: { (success, weather) in
            if success, let weather = weather {
                self.tempNewYork.text = weather.temperature

                if let data = weather.getImage(forCode: weather.code) {
                    self.imageNewYork.image = UIImage(data: data)
                }

                self.descriptionNewYork.text = "NEW-YORK (le " + weather.date + ")"

            } else {
                self.tempNewYork.text = "?"
                self.descriptionNewYork.text = "NEW-YORK (Problème de connexion)"
            }
        })
    }
}
