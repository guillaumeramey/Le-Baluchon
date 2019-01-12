//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit
import AVFoundation

class TranslateViewController: UIViewController {
    
    // MARK: - Properties
    private var sourceLanguage: Language!
    private var targetLanguage: Language!

    // MARK: - Outlets
    @IBOutlet var languages: [UILabel]!
    @IBOutlet var textViews: [UITextView]!
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var translateActivityIndicator: UIActivityIndicatorView!

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        userText.delegate = self

        // text placeholder
        userText.text = "Saisissez du texte"
        userText.textColor = UIColor.lightGray

        // apply design
        for textView in textViews {
            textView.layer.cornerRadius = 5.0
            textView.layer.borderColor = UIColor(named: "Color_bar")!.cgColor
            textView.layer.borderWidth = 1
            textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 30)
        }

        clearButton.isHidden = true

        sourceLanguage = .french
        targetLanguage = .english
    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Vérifiez votre connexion", message: "Nous ne sommes pas parvenus à traduire le texte.", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(actionOk)
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - Actions
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

    // convert the translated text into audio
    @IBAction func textToSpeech(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: translatedText.text!)
        let language = targetLanguage == .french ? "fr-FR" : "en-US"
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
}

// MARK: - Keyboard
extension TranslateViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userText.resignFirstResponder()
    }

    @IBAction func clearButtonPressed(_ sender: Any) {
        userText.text = ""
        translatedText.text = ""
    }
}

// MARK: - TextView placeholder
extension TranslateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        clearButton.isHidden = false
        if userText.textColor == UIColor.lightGray {
            userText.text = nil
            userText.textColor = UIColor(named: "Color_text")
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
