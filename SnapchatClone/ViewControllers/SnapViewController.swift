//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 11.12.2023.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher

class SnapViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!

    var selectedSnap: SnapModel?
    var inputArray = [KingfisherSource]()


    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedSnap = selectedSnap {

            timeLabel.text = "Time: \(selectedSnap.timeLeft)"
            for imageUrl in selectedSnap.imageUrlArray {


                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: view.frame.width * 0.95, height: view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.white
            imageSlideShow.contentScaleMode = .scaleAspectFit

            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.black
            pageIndicator.pageIndicatorTintColor = UIColor.lightGray
            imageSlideShow.pageIndicator = pageIndicator

            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
    }
}
