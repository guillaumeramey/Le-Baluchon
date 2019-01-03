//
//  WeatherTableViewController.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 02/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var selectedCities: [City]!

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateAI: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedCities = [City]()

        for city in cities where city.selected {
            selectedCities.append(city)
        }
        updateWeather()
    }

    private func updateWeather() {
        startUpdating()
        WeatherService.shared.getWeather { (success, weather) in
            if success, let weather = weather {

                guard weather.query.count == cities.count else {
                    fatalError("number of cities in query incorrect")
                }
                
                for (index, element) in self.selectedCities.enumerated() {
                    element.date = weather.query.results.channel[index].item.condition.dateFormatted
                    element.temperature = weather.query.results.channel[index].item.condition.temp + "°"
                    element.conditionCode = weather.query.results.channel[index].item.condition.code
                    element.caption = element.name + " " + element.displayDate
                }
            } else {
                for city in self.selectedCities {
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
        for city in selectedCities {
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
        return selectedCities.count
//        return cities.filter({ $0.selected }).count
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
