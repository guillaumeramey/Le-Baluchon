import UIKit

class TranslateViewController: UIViewController {

    var sourceLanguage: Language!
    var targetLanguage: Language!

    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var sourceLanguageLabel: UILabel!
    @IBOutlet weak var targetLanguageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawDesign()
        toggleLanguage(self)
    }

    func drawDesign() {
        userText.layer.cornerRadius = 5.0
        userText.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 30)
        translatedText.layer.cornerRadius = 5.0
    }

    @IBAction func toggleLanguage(_ sender: Any) {
        if sourceLanguage == .french {
            sourceLanguage = .english
            targetLanguage = .french
        } else {
            sourceLanguage = .french
            targetLanguage = .english
        }
        sourceLanguageLabel.text = languageString[sourceLanguage.rawValue]
        targetLanguageLabel.text = languageString[targetLanguage.rawValue]
    }

    @IBAction func translate(_ sender: Any) {
        TranslateService().translate(userText.text, sourceLanguage, targetLanguage, callback: { (success, translation) in
            if success, let translation = translation {
                self.translatedText.text = translation.translatedText
            } else {
                self.translatedText.text = "Impossible de traduire le texte"
            }
        })
    }

    @IBAction func clearButtonPressed(_ sender: Any) {
        userText.text = ""
    }
}

// MARK: - Keyboard
extension TranslateViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userText.resignFirstResponder()
        //clearButton.isHidden = true
    }
}
