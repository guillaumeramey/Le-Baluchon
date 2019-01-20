//
//  CitiesViewController.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {

    let sections = ["Affichées", "Disponibles"]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        tableView.isEditing = true
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension CitiesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        cell?.textLabel?.text = sections[section]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Persist.selectedCities.count
        case 1:
            return Persist.availableCities.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = Persist.selectedCities[indexPath.row].name
        case 1:
            cell.textLabel?.text = Persist.availableCities[indexPath.row].name
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - Table view Delegate methods
extension CitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedCity: City!

        if sourceIndexPath.section == 0 {
            movedCity = Persist.selectedCities.remove(at: sourceIndexPath.row)
        } else {
            movedCity = Persist.availableCities[sourceIndexPath.row]
        }
        
        if destinationIndexPath.section == 0 {
            Persist.selectedCities.insert(movedCity, at: destinationIndexPath.row)
        }
        tableView.reloadData()
    }
}
