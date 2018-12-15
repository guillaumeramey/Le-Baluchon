import UIKit

class ChangeViewController: UIViewController {

    @IBOutlet var amountInEuro: UITextField!
    @IBOutlet var amountInDollar: UITextField!
    @IBOutlet var rateUpToDate: UILabel!

    var change: Change!
    var rate: Float!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateRates()
    }

    private func updateRates() {
        ChangeService().getRates { (success, change) in
            if success, let change = change {
                self.change = change
                self.rateUpToDate.text = "Mis à jour le : " + change.date

                self.updateAmounts()
            } else {
                self.rateUpToDate.text = "Mise à jour impossible"
            }
        }
    }

    func updateAmounts() {
        self.amountInEuro.text =  "1"
        self.updateAmountInDollar()
    }
    func updateAmountInEuro() {
        amountInEuro.text =  change.convert(amountInDollar.text, fromCurrency: .dollarUS, toCurrency: .euro)
    }

    func updateAmountInDollar() {
        amountInDollar.text =  change.convert(amountInEuro.text, fromCurrency: .euro, toCurrency: .dollarUS)
    }

    @IBAction func amountInEuroEdited(_ sender: UITextField) {
        updateAmountInDollar()
    }

    @IBAction func amountInDollarEdited(_ sender: UITextField) {
        updateAmountInEuro()
    }
}

// MARK: - Keyboard
extension ChangeViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountInEuro.resignFirstResponder()
        amountInDollar.resignFirstResponder()
    }
}
