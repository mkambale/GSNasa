//
//  BaseViewController.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit
import MaterialComponents.MaterialProgressView

class BaseViewController: UIViewController {

    var pageType:PageType = .NONE
    weak var parentVC:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showActivityIndicator() {
        if let parent = parentVC {
            LoadingOverlay.shared.showOverlay(view: parent.view, message: "Loading...")
        }
    }
    
    func hideActivityIndicator() {
        LoadingOverlay.shared.fadeOutOverlay()
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
