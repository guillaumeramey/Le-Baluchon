//
//  WeatherTableViewController.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 02/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var cities: [City]!

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateAI: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        cities = [City]()

        for city in availableCities where city.selected {
            cities.append(city)
        }
        updateWeather()
    }

    private func updateWeather() {
        startUpdating()
        WeatherService.shared.getWeather(for: cities, callback: { (success, weatherJSON) in
            if success, let weatherJSON = weatherJSON {
                for (index, city) in self.cities.enumerated() {
                    city.temperature = "\(weatherJSON.list[index].main.temp)°"
                    city.date = weatherJSON.list[index].date
                    city.caption = city.name.uppercased() + " " + city.displayDate
                }

            } else {
                for city in self.cities {
                    city.caption = city.name + " (Problème de connexion)"
                }
            }
            self.endUpdating()
        })
    }

    private func startUpdating() {
        refreshButton.isEnabled = false
        refreshButton.tintColor = UIColor.white
        updateAI.startAnimating()
        for city in cities {
            city.caption = city.name + " (Mise à jour...)"
        }
    }

    private func endUpdating() {
        tableView.reloadData()
        updateAI.stopAnimating()
        refreshButton.tintColor = UIColor.darkText
        refreshButton.isEnabled = true
    }

    // MARK: - Actions
    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateWeather()
    }

    @IBAction func addButtonPressed(_ sender: Any) {

    }
}

// MARK: - Table view data source
extension WeatherViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        cell.background.image = cities[indexPath.row].background
        cell.temperature.text = cities[indexPath.row].temperature
        cell.conditionImage.image = cities[indexPath.row].conditionImage
        cell.caption.text = cities[indexPath.row].caption

        return cell
    }
}
