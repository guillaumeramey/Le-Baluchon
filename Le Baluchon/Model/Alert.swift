//
//  Alert.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

struct Alert {
    static func present(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        vc.present(alert, animated: true)
    }
}
