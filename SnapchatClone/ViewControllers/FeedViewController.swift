//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 8.12.2023.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    let firestoreDb = Firestore.firestore()
    let makeAlert = MakeAlert()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
    }


    func getUserInfo() {

        firestoreDb.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in

            if let error = error {
                let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
            } else {

                if snapshot?.isEmpty == false && snapshot != nil {

                    for document in snapshot!.documents {

                        if let userName = document.get("username") as? String {

                            UserSingleton.sharedUserInfo.username = userName
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                        }

                    }

                }

            }
        }



    }

}
