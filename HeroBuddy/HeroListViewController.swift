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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataRequester = DataRequester()
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
        
        // Do any additional setup after loading the view.
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

