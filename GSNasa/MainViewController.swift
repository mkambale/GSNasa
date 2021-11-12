//
//  MainViewController.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit

/// #MainViewController
/// This UI class's reponsibilities include -
/// Base class for all visiable UI
/// Has content view to have emebedded UIPageView cotroller
class MainViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageSegment: UISegmentedControl!
    
    private var basePageViewController: BasePageViewController?
    
    let formsCount = 3
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desinationViewController = segue.destination as? BasePageViewController {
            basePageViewController = desinationViewController
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        if basePageViewController != nil {
            basePageViewController?.changePageTo(page: PageType(rawValue: pageSegment.selectedSegmentIndex) ?? .NONE)
        }
    }
}
