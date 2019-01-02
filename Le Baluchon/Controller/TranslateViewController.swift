import UIKit
import AVFoundation

class TranslateViewController: UIViewController {
    
    // MARK: - Properties
    private var sourceLanguage: Language!
    private var targetLanguage: Language!

    // MARK: - Outlets
    @IBOutlet var languages: [UILabel]!
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var translateActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userText.delegate = self
        userText.text = "Saisissez du texte"
        userText.textColor = UIColor.lightGray
        userText.layer.cornerRadius = 5.0
        userText.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 30)

        translatedText.layer.cornerRadius = 5.0

        clearButton.isHidden = true

        sourceLanguage = .french
        targetLanguage = .english
    }

    // switch source and target languages
    @IBAction func toggleLanguage(_ sender: Any) {
        (sourceLanguage, targetLanguage) = (targetLanguage, sourceLanguage)

        UIView.beginAnimations(nil, context: nil)
        (languages[0].frame.origin, languages[1].frame.origin) = (languages[1].frame.origin, languages[0].frame.origin)
        UIView.commitAnimations()
    }

    // request a translation
    @IBAction func translate(_ sender: Any) {
        userText.resignFirstResponder()
        translatedText.text = ""
        translateActivityIndicator.startAnimating()

        TranslateService.shared.translate(userText.text, from: sourceLanguage, to: targetLanguage, callback: { (success, translation) in
            if success, let translation = translation {
                self.translatedText.text = translation.translatedText
            } else {
                self.presentAlert()
            }
            self.translateActivityIndicator.stopAnimating()
        })
    }

    // error alert
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Impossible de traduire le texte", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(actionOk)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Keyboard
extension TranslateViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userText.resignFirstResponder()
    }

    @IBAction func clearButtonPressed(_ sender: Any) {
        userText.text = ""
    }
}

// MARK: - TextView placeholder
extension TranslateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        clearButton.isHidden = false
        if userText.textColor == UIColor.lightGray {
            userText.text = nil
            userText.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        clearButton.isHidden = true
        if userText.text.isEmpty {
            userText.text = "Saisissez du texte"
            userText.textColor = UIColor.lightGray
        }
    }
}
