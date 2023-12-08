//
//  MakeAlert.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 8.12.2023.
//

import Foundation
import UIKit

struct MakeAlert {

    func makeAlert(titleInput: String, messageInput: String)-> UIAlertController {

        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)

        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)

        alert.addAction(okButton)
        
        return alert
    }
}
