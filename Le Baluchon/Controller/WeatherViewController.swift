//
//  WeatherTableViewController.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 02/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class WeatherTableViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeather()
    }

    private func updateWeather() {
        WeatherService.shared.getWeather { (success, weather) in
            if success, let weather = weather {

                for (index, element) in cities.enumerated() {
                    element.date = weather.query.results.channel[index].item.condition.dateFormatted
                    element.temperature = weather.query.results.channel[index].item.condition.temp + "°"
                    element.code = weather.query.results.channel[index].item.condition.code
                }

                self.tableView.reloadData()

            } else {

            }
        }
    }

    // MARK: - Actions
    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateWeather()
    }
}

// MARK: - Table view data source
extension WeatherTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        cell.background.image = cities[indexPath.row].background
        cell.temperature.text = cities[indexPath.row].temperature
        cell.conditionImage.image = cities[indexPath.row].weatherImage
        cell.cityDescription.text = cities[indexPath.row].name + " " + cities[indexPath.row].displayDate

        return cell
    }
}
