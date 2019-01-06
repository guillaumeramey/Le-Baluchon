//
//  WeatherTableViewController.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 02/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var cities: [City] {
        return availableCities.filter { $0.selected }
    }

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateAI: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        updateWeather()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        tableView.reloadData()
    }

    private func updateWeather() {
        startUpdating()
        WeatherService.shared.getWeather { (success, weather) in
            if success, let weather = weather {
                
                for (index, city) in self.cities.enumerated() {
                    city.date = weather.query.results.channel[index].item.condition.dateFormatted
                    city.temperature = weather.query.results.channel[index].item.condition.temp + "°"
                    city.conditionCode = weather.query.results.channel[index].item.condition.code
                    city.caption = city.name + " " + city.displayDate
                }
            } else {
                for city in self.cities {
                    city.caption = city.name + " (Problème de connexion)"
                }
            }
            self.endUpdating()
        }
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
