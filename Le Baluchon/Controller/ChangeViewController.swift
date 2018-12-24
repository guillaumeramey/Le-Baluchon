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

        createClearButtons()
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
                self.presentAlert()
            }
        }
    }

    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateRates()
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
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Impossible de mettre à jour le taux de change", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(actionOk)
        let actionRetry = UIAlertAction(title: "Réessayer", style: .default, handler: retryHandler)
        alertVC.addAction(actionRetry)
        present(alertVC, animated: true, completion: nil)
    }

    private func retryHandler(alert: UIAlertAction!) {
        updateRates()
    }


    // white status bar functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Keyboard
extension ChangeViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        for amount in amounts {
            amount.resignFirstResponder()
        }
    }

    // creates a white clear button in the keyboard for all textfields
    private func createClearButtons() {
        for amount in amounts {
            let height = amount.bounds.height / 3
            let width = height + 10
            let rect = CGRect(x: 0, y: 0, width: width, height: height)

            let clearButton = UIButton(frame: rect)
            clearButton.setImage(UIImage(named: "clear button white"), for: .normal)
            clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)

            amount.rightView = clearButton
            amount.rightViewMode = .whileEditing
        }
    }

    @objc private func clearButtonPressed(sender: UIButton) {
        for amount in amounts {
            amount.text = ""
        }
    }
}
