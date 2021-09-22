//
//  HeroDetailViewController.swift
//  HeroBuddy
//
//  Created by Stephen Nary on 9/22/21.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    @IBOutlet weak var thumbnailView: UIImageView?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    var heroItem: HeroListItem? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    

    func updateView() {
        guard let heroItem = heroItem else { return }
        navigationItem.title = heroItem.name
        thumbnailView?.image = heroItem.thumbnail
        descriptionLabel?.text = heroItem.description
    }

}
