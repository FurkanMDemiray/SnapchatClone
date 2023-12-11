//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 11.12.2023.
//

import UIKit

class SnapViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!

    var selectedTimeLeft: Int?
    var selectedSnap: SnapModel?


    override func viewDidLoad() {
        super.viewDidLoad()

        if let timeLeft = selectedTimeLeft {
            timeLabel.text = "Time Left: \(timeLeft)"
        }

    }




}
