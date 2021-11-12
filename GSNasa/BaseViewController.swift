//
//  BaseViewController.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit

class BaseViewController: UIViewController {

    var pageType:PageType = .NONE
    weak var parentVC:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showActivityIndicator() {
        LoadingOverlay.shared.showOverlay(view: self.view, message: "Loading...")
    }
    
    func hideActivityIndicator() {
        LoadingOverlay.shared.fadeOutOverlay()
    }
    
    func showDisplayView(forDate:Date) {
        if let parent = parentVC {
            let displayVC = DisplayViewController.getInstance(.NONE, parent: nil, forDate: forDate)
            parent.present(displayVC, animated: true, completion: nil)
        }
    }
    
    func showDisplayView(media:Media) {
        if let parent = parentVC {
            let displayVC = DisplayViewController.getInstance(.NONE, parent: nil)
            displayVC.mediaInfo = media
            parent.present(displayVC, animated: true, completion: nil)
            displayVC.configureView()
        }
    }
}
