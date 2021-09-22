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
        
        dataRequester.getThumbnail(url: thumbnailURL) { image, error in
            guard let image = image else { return }
            DispatchQueue.main.async {
                heroCell.thumbnailView?.image = image
                heroCell.setNeedsLayout()
            }

        }
    }
}

