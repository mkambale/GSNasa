//
//  FavoritesViewController.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit

class FavoritesViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var favorites = [Media]()
    
    static func getInstance(_ type:PageType, parent:UIViewController) -> FavoritesViewController {
      let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FavoritesViewController") as! FavoritesViewController
        vc.pageType = type
        vc.parentVC = parent
      return vc
    }

    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
    func setup() {
        favorites = MediaDetailManager.shared.getAllMedia()
        if favorites.count > 0 {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
      
    func unfavoriteThis(_ media:Media,_ row:Int) {
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            action in
            DispatchQueue.main.async {
                if self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) != nil {
                    self.favorites.remove(at: row)
                    MediaDetailManager.shared.removeFromFavorites(media: media)
                    self.tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
                    self.tableView.reloadData()
                }
            }
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: {
            action in
        })
        
        Helper.showAlert(withtitle: "Unfavorite", andMessage: "Do you want to unfavorite this?", onView: self, okaction: deleteAction, otheraction: noAction)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell") as! DetailsTableViewCell
        cell.config(detail: favorites[indexPath.row])
        cell.unfavoriteAction = unfavoriteThis
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DetailsTableViewCell,
           let media = cell.details {
            self.showDisplayView(media: media)
        }
    }
}
