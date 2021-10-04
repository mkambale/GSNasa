//
//  BasePageViewController.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit


/**
    This UI class's reponsibilities include -
 - Has embedded UIPageViewContrller to let the user see Todays Image, searc for image and see the already favorited images.
 - Intantiates all three screens of PageView controller and manages the navigation between pages.
*/

class BasePageViewController: UIPageViewController {

    var individualPageViewControllerList = [UIViewController]()
    var currentPage:PageType = .NONE
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        setUpPageViews()
        dataSource = self
    }
    
    func setUpPageViews() {
        
        let displayViewController = DisplayViewController.getInstance(.TODAYS, parent: self)
        let searchViewController = SearchViewController.getInstance(.SEARCH, parent: self)
        let favoritesViewController = FavoritesViewController.getInstance(.FAVORITES, parent: self)

        individualPageViewControllerList = [
            displayViewController,
            searchViewController,
            favoritesViewController
        ]

        setViewControllers([individualPageViewControllerList[0]], direction: .forward, animated: true, completion: nil)
        
        currentPage = .TODAYS
    }
    
    func changePageTo(page: PageType) {
        
        if page.rawValue == currentPage.rawValue || page == .NONE {
            return
        }
 
        //move back
        let nextVC = individualPageViewControllerList[page.rawValue]
        
        if page.rawValue < currentPage.rawValue {
            setViewControllers([nextVC], direction: .reverse, animated: true, completion: nil)
        } else { //move forward
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
        
        currentPage = page
    }
}

extension BasePageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      let indexOfCurrentPageViewController = individualPageViewControllerList.firstIndex(of: viewController)!
    if indexOfCurrentPageViewController == 0 {
     return nil // To show there is no previous page
    } else {
      // Previous UIViewController instance
      return individualPageViewControllerList[indexOfCurrentPageViewController - 1]
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      let indexOfCurrentPageViewController = individualPageViewControllerList.firstIndex(of: viewController)!
    if indexOfCurrentPageViewController == individualPageViewControllerList.count - 1 {
      return nil // To show there is no next page
    } else {
      // Next UIViewController instance
      return individualPageViewControllerList[indexOfCurrentPageViewController + 1]
    }
  }
}
