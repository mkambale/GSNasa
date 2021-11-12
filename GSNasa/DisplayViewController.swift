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
class DisplayViewController: BaseViewController, UIScrollViewDelegate {
    
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
    
    private var forDate:Date?
    var mediaInfo:Media?
    
    static func getInstance(_ type:PageType, parent:UIViewController?) -> DisplayViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DisplayViewController") as! DisplayViewController
        vc.pageType = type
        vc.parentVC = parent
        return vc
    }
    
    static func getInstance(_ type:PageType, parent:UIViewController?, forDate:Date) -> DisplayViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DisplayViewController") as! DisplayViewController
        vc.pageType = type
        vc.parentVC = parent
        vc.forDate = forDate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        detailsScrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setup() {
        guard let date = forDate else {
            return
        }
        
        heartButton.onImage = UIImage(named: "heart_filled")
        heartButton.offImage = UIImage(named: "heart_empty")
        
        let forDateString = Helper.convertToStringFromDate(date: date, outputFormat: .usStandardForm)
        
        showActivityIndicator()
        
        MediaDetailManager.shared.getMediaForDate(date: forDateString) {
            mediaInfo, data, result in
            
            if result == .SUCCESS, let media = mediaInfo, let imageData = data {
                self.mediaInfo = Media(details: media, fileData: imageData)
                self.configureView()
            } else if result == .MEDIA_ISSUE {
                let closeAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                    self.closeIfNeeded()
                })
                Helper.showAlert(withtitle: "Not Supported", andMessage: "For selected date, there is video exists not image.", onView: self, okaction: closeAction)
            } else {
                let closeAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                    self.closeIfNeeded()
                })
                Helper.showAlert(withtitle: "Not Supported", andMessage: serverErrorMessage, onView: self, okaction: closeAction)
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
        if mediaInfo == nil {
            return
        }
        
        if !heartButton.status { //save to disk
            mediaInfo?.isFavorite = true

            let result = MediaDetailManager.shared.saveToFavorites(media: mediaInfo!)
            
            if !result {
                Helper.showError(forView: self)
            }
        } else { //remove from disk
            
            let deleteAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
                action in
                DispatchQueue.main.async {
                    self.mediaInfo?.isFavorite = false
                    MediaDetailManager.shared.removeFromFavorites(media: self.mediaInfo!)
                }
            })
            
            let noAction = UIAlertAction(title: "No", style: .default, handler: {
                action in
                
                //reset
                self.heartButton.toggle()
            })
            
            Helper.showAlert(withtitle: "Unfavorite", andMessage: "Do you want to unfavorite this?", onView: self, okaction: deleteAction, otheraction: noAction)
            
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
        } else {
            heartButton.setStatus(false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func closeIfNeeded() {
        if self.presentingViewController?.presentedViewController == self {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension DisplayViewController: FavoritesChangeStateProtocol {
    func didChangeFavState(state: Bool) {
        if !state {
            mediaInfo?.isFavorite = false
            MediaDetailManager.shared.removeFromFavorites(media: self.mediaInfo!)
        }
    }
    
}

