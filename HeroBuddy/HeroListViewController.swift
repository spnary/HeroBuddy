//
//  ViewController.swift
//  HeroBuddy
//
//  Created by Stephen Nary on 9/20/21.
//

import UIKit

class HeroListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    
    var heroList: [HeroListItem] = []
    let dataRequester = DataRequester()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataRequester.getCharacters() { [weak self] response, error in
            guard let response = response else {
                print("Missing response data")
                return
            }
            self?.heroList = heroListItemsFromJsonObject(response)
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
            
        }
    }


}

extension HeroListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heroListCell") ?? UITableViewCell()
        guard let heroListCell = cell as? HeroListTableViewCell else {
            return cell
        }
        let heroItem = heroList[indexPath.row]
        heroListCell.nameLabel?.text = heroItem.name
        heroListCell.thumbnailView?.image = heroItem.thumbnail ?? UIImage(systemName: "person.fill")
        return heroListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension HeroListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let heroItem = heroList[indexPath.row]
        guard let heroCell = cell as? HeroListTableViewCell, let thumbnailURL = URL(string: heroItem.thumbnailURL) else { return }
        
        if heroItem.thumbnail == nil {
            dataRequester.getThumbnail(url: thumbnailURL) { [weak self] image, error in
                guard let image = image else { return }
                self?.heroList[indexPath.row].thumbnail = image
                DispatchQueue.main.async {
                    heroCell.thumbnailView?.image = image
                    heroCell.setNeedsLayout()
                }

            }
        }
    }
}

