//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 8.12.2023.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let db = Firestore.firestore()
    let makeAlert = MakeAlert()

    let imageArray = [UIImage]()
    let userNameArray = [String]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        getUserInfo()

    }
    override func viewWillAppear(_ animated: Bool) {
        getSnapsFromFirebase()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell

        cell.userNameLbl.text = userNameArray[indexPath.row]
        cell.imageView?.image = imageArray[indexPath.row]

        return cell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
*/
    func getUserInfo() {

        db.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in

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
    func getSnapsFromFirebase() {

        db.collection("Snaps").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if let error = error {
                let alert = self.makeAlert.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
            } else {

                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let imageUrlArray = document.get("imageUrlArray") as! [String]
                        print(imageUrlArray)
                    }
                }

            }

        }


    }

}
