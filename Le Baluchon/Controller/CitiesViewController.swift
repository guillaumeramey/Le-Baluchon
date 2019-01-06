//
//  CitiesViewController.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 03/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension CitiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        let city = availableCities[indexPath.row]
        cell.textLabel?.text = city.name
        cell.accessoryType = city.selected ? .checkmark : .none

        return cell
    }
}

// MARK: - Table view Delegate methods
extension CitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        availableCities[indexPath.row].selected.toggle()
        tableView.reloadData()
    }
}
