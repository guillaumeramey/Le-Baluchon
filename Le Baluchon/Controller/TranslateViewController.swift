import UIKit

class TranslateViewController: UIViewController {

    enum Language: String {
        case french = "fr"
        case english = "en"
    }
    let languageString = ["fr" : "Français",
                          "en" : "Anglais"]
    var translation: Translation!
    var sourceLanguage: Language!
    var targetLanguage: Language!

    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var sourceLanguageLabel: UILabel!
    @IBOutlet weak var targetLanguageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawDesign()
        toggleLanguage(self)
    }

    func drawDesign() {
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        userText.layer.borderWidth = 0.5
        userText.layer.borderColor = borderColor.cgColor
        userText.layer.cornerRadius = 5.0
        translatedText.layer.borderWidth = 0.5
        translatedText.layer.borderColor = borderColor.cgColor
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
        TranslateService().translate(query: userText.text, sourceLanguage: sourceLanguage.rawValue, targetLanguage: targetLanguage.rawValue, callback: { (success, translation) in
            if success, let translation = translation {
                self.translation = translation
                self.translatedText.text = self.translation.data.translations[0].translatedText
            } else {
                self.translatedText.text = "Erreur quelque part"
            }
        })
    }
}
