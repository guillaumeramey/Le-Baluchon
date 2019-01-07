//
//  WeatherTableViewController.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 02/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var selectedCities: [City] {
        return cities.filter { $0.selected }
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
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func updateWeather() {
        startUpdating()
        WeatherService.shared.getWeather(for: cities, callback: { (success, weatherJSON) in
            if success, let weatherJSON = weatherJSON {
                for (index, city) in cities.enumerated() {
                    city.temperature = "\(Int(weatherJSON.list[index].main.temp.rounded()))°"
                    city.date = weatherJSON.list[index].date
                    city.caption = city.name.uppercased() + " " + city.displayDate
                    city.conditionImage = UIImage(named: weatherJSON.list[index].weather[0].conditionImage)
                }
            } else {
                for city in cities {
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedCities[indexPath.row].selected = false
            tableView.reloadData()
        }
    }
}
