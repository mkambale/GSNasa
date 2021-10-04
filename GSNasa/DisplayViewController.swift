//
//  DisplayViewController.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit

/**
    This UI class's reponsibilities include -
 - Fetch the image for the day from API and populate the details.
 - Allow user to set image as favorite and un-favorite
*/
class DisplayViewController: BaseViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var mediaMainView: UIView!
    @IBOutlet weak var mediaView: UIView!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var detailsContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var copyRightLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heartButton: SwitchButton!
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var mediaInfo:Media?
    
    static func getInstance(_ type:PageType, parent:UIViewController?) -> DisplayViewController {
      let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DisplayViewController") as! DisplayViewController
        vc.pageType = type
        vc.parentVC = parent
      return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setup() {
        heartButton.onImage = UIImage(named: "heart_filled")
        heartButton.offImage = UIImage(named: "heart_empty")
        
        //get image for today
        let todaysDate = Helper.convertToStringFromDate(date: Date(), outputFormat: .usStandardForm)
        
        showActivityIndicator()
        
        MediaDetailManager.shared.getMediaForDate(date: todaysDate) {
            mediaInfo, data, result in
            
            if result == .SUCCESS, let media = mediaInfo, let imageData = data {
                self.mediaInfo = Media(details: media, fileData: imageData)
                self.configureView()
            } else {
                //show default error for now
                Helper.showError(forView:self)
            }
            
            self.hideActivityIndicator()
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation == .portrait || fromInterfaceOrientation == .portraitUpsideDown {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }
    
    @IBAction func heartButtonTapped(_ sender: Any) {
        guard let info = mediaInfo else {
            return
        }

        if !heartButton.status { //save to disk
            let result = MediaDetailManager.shared.saveToFavorites(media: info)
            
            if !result {
                Helper.showError(forView: self)
            }
        } else { //remove from disk
            MediaDetailManager.shared.removeFromFavorites(media: info)
        }
    }
    
    func configureView() {
        guard let info = mediaInfo, let imageData = info.image.image else {
            return
        }
        
        //TODO - local cache
        //mediaImageView.image = MediaDetailManager.shared.getImageForMedia(media: info)
        mediaImageView.image = UIImage(data:imageData, scale:1.0)
        titleLabel.text = info.details.title
        copyRightLabel.text = info.details.copyright ?? ""
        dateLabel.text = info.details.date
        descriptionLabel.text = info.details.explanation
        
        if info.isFavorite {
            heartButton.setStatus(true)
        }
    }
    
}

