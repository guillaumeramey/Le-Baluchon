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

    override func viewDidLoad() {
        super.viewDidLoad()
        updateRates()

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
                self.change = change
                self.lastUpdate.text = "Mis à jour le " + change.dateFormatted
                self.amounts[0].text = "1"
                self.amounts[1].text =  change.convert(self.amounts[0].text, from: .euro, to: .dollarUS)
                for amount in self.amounts {
                    amount.isEnabled = true
                }
            } else {
                self.lastUpdate.text = "Mise à jour impossible"
                self.presentAlert(with: "Impossible de mettre à jour le taux de change")
            }
            self.stopUpdating()
        }
    }

    private func startUpdating() {
        refreshButton.isEnabled = false
        refreshButton.tintColor = UIColor(named: "Color_bar")!
        updateAI.startAnimating()
        for amount in amounts {
            amount.isEnabled = false
        }
        lastUpdate.text = "Mise à jour du taux de change..."
    }

    private func stopUpdating() {
        updateAI.stopAnimating()
        refreshButton.tintColor = UIColor(named: "Color_background")!
        refreshButton.isEnabled = true
    }

    @IBAction func refreshButtonPressed(_ sender: Any) {
        if ChangeService.shared.isUpdateNeeded {
            updateRates()
        } else {
            presentAlert(with: "Le taux de change est déjà à jour.")
        }
    }

    @IBAction func amountEdited(_ sender: UITextField) {
        switch sender.tag {
        case 1:
            amounts[1].text = change.convert(amounts[0].text, from: .euro, to: .dollarUS)
        case 2:
            amounts[0].text = change.convert(amounts[1].text, from: .dollarUS, to: .euro)
        default:
            break
        }
    }
    
    // move the currency currently edited to the top
    @IBAction func amountEditingDidBegin(_ sender: UITextField) {
        if topView.tag != sender.tag {
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

    // error alert
    private func presentAlert(with message: String) {
        let alertVC = UIAlertController(title: "Alerte", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(actionOk)
        present(alertVC, animated: true, completion: nil)
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
