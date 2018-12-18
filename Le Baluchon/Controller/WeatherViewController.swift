import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var tempParis: UILabel!
    @IBOutlet weak var tempNewYork: UILabel!
    @IBOutlet weak var textParis: UILabel!
    @IBOutlet weak var textNewYork: UILabel!
    @IBOutlet weak var imageParis: UIImageView!
    @IBOutlet weak var imageNewYork: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateWeather()
    }

    func updateWeather() {
        WeatherService().getWeather(for: .paris, callback: { (success, weather) in
            if success, let weather = weather {
                self.tempParis.text = weather.temperature
                self.textParis.text = weather.description

                self.imageParis.image = UIImage(data: weather.getImage(forCode: weather.code)!)

            } else {
                self.tempParis.text = "?"
            }
        })

        WeatherService().getWeather(for: .newyork, callback: { (success, weather) in
            if success, let weather = weather {
                self.tempNewYork.text = weather.temperature
                self.textNewYork.text = weather.description

                self.imageNewYork.image = UIImage(data: weather.getImage(forCode: weather.code)!)

            } else {
                self.tempNewYork.text = "?"
            }
        })
    }
}
