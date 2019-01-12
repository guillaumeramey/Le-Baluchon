//
//  WeatherTableViewController.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var weatherTableView: UITableView!

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.updateWeather), for: .valueChanged)
        weatherTableView.refreshControl = refreshControl

        refreshControl.beginRefreshingWithAnimation()
        updateWeather()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weatherTableView.reloadData()
    }

    @objc private func updateWeather() {
        WeatherService.shared.getWeather(for: allCities, callback: { (success, weatherJSON) in
            if success, let weatherJSON = weatherJSON {
                for (index, city) in allCities.enumerated() {
                    city.temperature = "\(Int(weatherJSON.list[index].main.temp.rounded()))°"
                    city.date = weatherJSON.list[index].date
                    city.caption = city.name.uppercased() + " " + city.displayDate
                    city.conditionImage = UIImage(named: weatherJSON.list[index].weather[0].conditionImage)
                }
            } else {
                self.presentAlert()
            }
            self.weatherTableView.reloadData()
            self.weatherTableView.refreshControl?.endRefreshing()
        })
    }

    // error alert
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Vérifiez votre connexion", message: "Nous ne sommes pas parvenus à récupérer la météo.", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(actionOk)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension WeatherViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        cell.background.image = selectedCities[indexPath.row].background
        cell.temperature.text = selectedCities[indexPath.row].temperature
        cell.conditionImage.image = selectedCities[indexPath.row].conditionImage
        cell.caption.text = selectedCities[indexPath.row].caption

        return cell
    }
}

// MARK: - Table view delegate
extension WeatherViewController: UITableViewDelegate {

    // create a swipe action to hide cells
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let hideAction = UIContextualAction(style: .normal, title: "Masquer") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            selectedCities.remove(at: indexPath.row)
            self.weatherTableView.reloadData()
        }
        hideAction.backgroundColor = UIColor(named: "Color_bar")

        return UISwipeActionsConfiguration(actions: [hideAction])
    }
}

extension UIRefreshControl {

    func beginRefreshingWithAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let scrollView = self.superview as? UIScrollView {
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.height), animated: true)
            }
            self.beginRefreshing()
        }
    }
}
