import UIKit

class ChangeViewController: UIViewController {

    // MARK: - Properties
    private var change: Change!
    private var rate: Float!
    private var topView: UIStackView!

    // MARK: - Outlets
    @IBOutlet weak var rateUpToDate: UILabel!
    @IBOutlet var currencies: [UIStackView]!
    @IBOutlet var amounts: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateRates()

        topView = currencies[0]

    }

    // API request to update currencies rates
    private func updateRates() {
        for amount in amounts {
            amount.isEnabled = false
        }
        self.rateUpToDate.text = "Mise à jour du taux de change..."
        
        ChangeService.shared.getRates { (success, change) in
            if success, let change = change {
                self.change = change
                self.rateUpToDate.text = "Mis à jour le " + change.dateFormatted
                self.amounts[0].text = "1"
                self.amounts[1].text =  change.convert(self.amounts[0].text, from: .euro, to: .dollarUS)
                for amount in self.amounts {
                    amount.isEnabled = true
                }
            } else {
                self.rateUpToDate.text = "Mise à jour impossible"
                self.alert(with: "Impossible de mettre à jour le taux de change")
            }
        }
    }

    @IBAction func refreshButtonPressed(_ sender: Any) {
        ChangeService.shared.isUpdateNeeded ? updateRates() : alert(with: "Le taux de change est déjà à jour.")
    }

    @IBAction func amountEdited(_ sender: UITextField) {
        switch sender.tag {
        case 1:
            amounts[1].text = change.convert(amounts[0].text, from: .euro, to: .dollarUS)
        case 2:
            amounts[0].text =  change.convert(amounts[1].text, from: .dollarUS, to: .euro)
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
    private func alert(with message: String) {
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
