import UIKit

class ChangeViewController: UIViewController {

    @IBOutlet weak var amountInEuro: UITextField!
    @IBOutlet weak var amountInDollar: UITextField!
    @IBOutlet weak var rateUpToDate: UILabel!
    @IBOutlet weak var euroView: UIStackView!
    @IBOutlet weak var dollarView: UIStackView!
    
    private var change: Change!
    private var rate: Float!
    private var topView = "EUR"

    override func viewDidLoad() {
        super.viewDidLoad()

        updateRates()
        amountInEuro.isEnabled = false
        amountInDollar.isEnabled = false

        createClearButton(for: amountInEuro)
        createClearButton(for: amountInDollar)
    }

    private func updateRates() {
        self.rateUpToDate.text = "Mise à jour du taux de change..."
        ChangeService.shared.getRates { (success, change) in
            if success, let change = change {
                self.change = change
                self.rateUpToDate.text = "Mis à jour le " + change.dateFormatted
                self.updateAmounts()
            } else {
                self.rateUpToDate.text = ""
                self.presentAlert()
            }
        }
    }

    private func updateAmounts() {
        amountInEuro.text =  "1"
        updateAmountInDollar()
        amountInEuro.isEnabled = true
        amountInDollar.isEnabled = true
    }

    private func updateAmountInEuro() {
        amountInEuro.text =  change.convert(amountInDollar.text, from: .dollarUS, to: .euro)
    }

    private func updateAmountInDollar() {
        amountInDollar.text =  change.convert(amountInEuro.text, from: .euro, to: .dollarUS)
    }

    @IBAction func amountInEuroEdited(_ sender: UITextField) {
        updateAmountInDollar()
    }

    @IBAction func amountInDollarEdited(_ sender: UITextField) {
        updateAmountInEuro()
    }

    @IBAction func amountInEuroEditingDidBegin(_ sender: Any) {
        if topView != "EUR" {
            switchViews()
            topView = "EUR"
        }
    }

    @IBAction func amountInDollarEditingDidBegin(_ sender: Any) {
        if topView != "USD" {
            switchViews()
            topView = "USD"
        }
    }

    private func switchViews() {
        UIView.beginAnimations(nil, context: nil)
        (euroView.frame.origin, dollarView.frame.origin) = (dollarView.frame.origin, euroView.frame.origin)
        UIView.commitAnimations()
    }

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

    private func createClearButton(for textField: UITextField) {
        let height = textField.bounds.height / 3
        let width = height + 10
        let rect = CGRect(x: 0, y: 0, width: width, height: height)

        let clearButton = UIButton(frame: rect)
        clearButton.setImage(UIImage(named: "clear button white"), for: .normal)
        clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)

        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
    }

    @objc private func clearButtonPressed(sender: UIButton) {
        amountInEuro.text = ""
        amountInDollar.text = ""
    }

    // white status bar
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
        amountInEuro.resignFirstResponder()
        amountInDollar.resignFirstResponder()
    }
}
