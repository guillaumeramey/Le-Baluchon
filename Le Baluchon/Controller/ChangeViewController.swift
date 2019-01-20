//
//  ChangeViewController.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {

    // MARK: - Properties
    private var change: Change!
    private var topView: UIStackView!

    // MARK: - Outlets
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet var currencies: [UIStackView]!
    @IBOutlet var amounts: [UITextField]!
    @IBOutlet weak var updateAI: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if ChangeService.shared.isUpdateNeeded {
            updateRates()
        } else {
            if let date = ChangeService.lastUpdate, let rates = ChangeService.lastRates {
                change = Change(date: date, rates: rates)
            }
            updateDisplay()
        }

        // apply design
        for textView in amounts {
            textView.layer.cornerRadius = 5.0
            textView.layer.borderColor = UIColor(named: "Color_bar")!.cgColor
            textView.layer.borderWidth = 1
        }
        
        topView = currencies[0]
    }

    // API request to update currencies rates
    private func updateRates() {
        startUpdating()
        ChangeService.shared.getRates { (success, change) in
            if success, let change = change {
                self.change = Change(date: change.getDate, rates: change.rates)
                self.updateDisplay()
                for amount in self.amounts {
                    amount.isEnabled = true
                }
            } else {
                Alert.present(title: "Vérifiez votre connexion", message: "Nous ne sommes pas parvenus à récupérer les taux de change.", vc: self)
            }
            self.stopUpdating()
        }
    }

    private func updateDisplay() {
        lastUpdate.text = "Mis à jour le " + change.displayDate()
        amounts[0].text = "1"
        amounts[1].text =  change.convert(amounts[0].text, from: .euro, to: .dollarUS)
    }

    private func startUpdating() {
        refreshButton.isEnabled = false
        refreshButton.tintColor = UIColor(named: "Color_bar")!
        updateAI.startAnimating()
        for amount in amounts {
            amount.isEnabled = false
        }
    }

    private func stopUpdating() {
        updateAI.stopAnimating()
        refreshButton.tintColor = UIColor(named: "Color_background")!
        refreshButton.isEnabled = true
    }

    // MARK: - Actions
    @IBAction func refreshButtonPressed(_ sender: Any) {
        if ChangeService.shared.isUpdateNeeded {
            updateRates()
        } else {
            Alert.present(title: "Vous êtes à jour.", message: "Les taux de change sont mis à jour quotidiennement.", vc: self)
        }
    }

    // perform a currency change everytime the user enter a number
    @IBAction func amountEdited(_ sender: UITextField) {
        switch sender.tag {
        case 0:
            amounts[1].text = change.convert(amounts[0].text, from: .euro, to: .dollarUS)
        case 1:
            amounts[0].text = change.convert(amounts[1].text, from: .dollarUS, to: .euro)
        default:
            break
        }
    }
    
    // move the currency currently edited to the top
    @IBAction func amountEditingDidBegin(_ sender: UITextField) {
        if topView.tag != sender.tag {
            // find the stackview with the same tag than the textfield
            for currency in currencies where currency.tag == sender.tag {
                switchViews(currency, topView)
                topView = currency
            }
        }
    }

    private func switchViews(_ view1: UIView, _ view2: UIView) {
        UIView.beginAnimations(nil, context: nil)
        (view1.frame.origin, view2.frame.origin) = (view2.frame.origin, view1.frame.origin)
        UIView.commitAnimations()
    }
}

// MARK: - Keyboard
extension ChangeViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        for amount in amounts {
            amount.resignFirstResponder()
        }
    }
}
