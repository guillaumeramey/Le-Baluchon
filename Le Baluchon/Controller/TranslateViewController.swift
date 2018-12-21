import UIKit
import AVFoundation

class TranslateViewController: UIViewController {

    private var sourceLanguage: Language!
    private var targetLanguage: Language!

    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var frenchLanguageLabel: UILabel!
    @IBOutlet weak var englishLanguageLabel: UILabel!
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

        translateActivityIndicator.isHidden = true

        toggleLanguage(self)
    }

    @IBAction func toggleLanguage(_ sender: Any) {
        if sourceLanguage == .french {
            sourceLanguage = .english
            targetLanguage = .french
        } else {
            sourceLanguage = .french
            targetLanguage = .english
        }

        UIView.beginAnimations(nil, context: nil)
        (frenchLanguageLabel.frame.origin, englishLanguageLabel.frame.origin) = (englishLanguageLabel.frame.origin, frenchLanguageLabel.frame.origin)
        UIView.commitAnimations()
    }

    @IBAction func translate(_ sender: Any) {
        userText.resignFirstResponder()
        translatedText.text = ""
        translateActivityIndicator.isHidden = false

        TranslateService.shared.translate(userText.text, sourceLanguage, targetLanguage, callback: { (success, translation) in
            if success, let translation = translation {
                self.translateActivityIndicator.isHidden = true
                self.translatedText.text = translation.translatedText
            } else {
                self.translateActivityIndicator.isHidden = true
                self.presentAlert()
            }
        })
    }

    @IBAction func clearButtonPressed(_ sender: Any) {
        userText.text = ""
    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Impossible de traduire le texte", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(actionOk)
        present(alertVC, animated: true, completion: nil)
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
extension TranslateViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userText.resignFirstResponder()
    }
}

// MARK: - TextView placeholder
extension TranslateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        clearButton.isHidden = false
        if userText.textColor == UIColor.lightGray {
            userText.text = nil
            userText.textColor = UIColor.white
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
