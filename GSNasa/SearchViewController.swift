//
//  SearchViewController.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit

/**
    This UI class's reponsibilities include -
 - Displaying calender to user for selection.
 - Download image from API and save it local cache.
 - Invoke DisplayViewController with downloaded data to show the image and details.
*/

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
        self.showDisplayView(forDate: calenderView.date)
    }
    
}
