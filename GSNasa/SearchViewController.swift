//
//  SearchViewController.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var calenderView: UIDatePicker!
    //@IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchButton: UIButton!
    
    static func getInstance(_ type:PageType, parent:UIViewController) -> SearchViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        vc.pageType = type
        vc.parentVC = parent
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        calenderView.date = Date()
        calenderView.maximumDate = Date()
        calenderView.datePickerMode = .date
        if #available(iOS 14.0, *) {
            calenderView.preferredDatePickerStyle = .inline
        } else {
        }
        calenderView.tintColor = UIColor.gs_theme
        
        let date = Helper.convertToStringFromDate(date: Date(), outputFormat: .fullMonthForm)
        searchButton.setTitle("Search for \(date)", for: .normal)
    }
    
    @IBAction func dateSelected(_ sender: Any) {
        let date = Helper.convertToStringFromDate(date: calenderView.date, outputFormat: .fullMonthForm)
        searchButton.setTitle("Search for \(date)", for: .normal)
    }
    
    @IBAction func SearchTapped(_ sender: Any) {
        print("searching for  \(calenderView.date)")
        let selectedDate = Helper.convertToStringFromDate(date: calenderView.date, outputFormat: .usStandardForm)

        MediaDetailManager.shared.getMediaForDate(date: selectedDate) {
            mediaInfo, data, result in
            
            if result == .SUCCESS, let media = mediaInfo, let imageData = data {
                let mediaInfo = Media(details: media, fileData: imageData)
                self.showDisplayView(media: mediaInfo)
            } else {
                //show default error for now
                Helper.showError(forView:self)
            }
            
            self.hideActivityIndicator()
        }
    }
    
}
