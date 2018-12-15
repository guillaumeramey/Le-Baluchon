import UIKit

class TranslateViewController: UIViewController {

    var translation: Translation!
    var sourceLanguage = ""
    var targetLanguage = ""

    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var frenchLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage(self)
    }


    @IBAction func changeLanguage(_ sender: Any) {
        if sourceLanguage == "fr" {
            sourceLanguage = "en"
            targetLanguage = "fr"
            englishLabel.layer.borderWidth = 2.0
            englishLabel.layer.cornerRadius = 8
            frenchLabel.layer.borderWidth = 0
            frenchLabel.layer.cornerRadius = 0
        } else {
            sourceLanguage = "fr"
            targetLanguage = "en"
            frenchLabel.layer.borderWidth = 2.0
            frenchLabel.layer.cornerRadius = 8
            englishLabel.layer.borderWidth = 0
            englishLabel.layer.cornerRadius = 0
        }
    }

    @IBAction func translate(_ sender: Any) {
        TranslateService().translate(query: userText.text, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, callback: { (success, translation) in
            if success, let translation = translation {
                self.translation = translation
                self.translatedText.text = self.translation.data.translations[0].translatedText
            } else {
                self.translatedText.text = "Erreur quelque part"
            }
        })
    }
}
