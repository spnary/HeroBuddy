//
//  HeroListItem.swift
//  HeroBuddy
//
//  Created by Stephen Nary on 9/20/21.
//

import UIKit

struct HeroListItem {
    let id: String
    let name: String
    let thumbnailURL: String
    var thumbnail: UIImage?
}

func heroListItemsFromJsonObject(_ object: [AnyHashable: Any]) -> [HeroListItem] {
    guard let characterData = object["data"] as? [AnyHashable: Any] else {
        print("Missing data")
        return []
    }
    guard let characterResults = characterData["results"] as? [Any] else {
        print("missing results")
        return []
    }
    var characters: [HeroListItem] = []
    for character in characterResults {
        guard let character = character as? [AnyHashable: Any],
              let id = character["id"] as? Int,
              let name = character["name"] as? String,
              let thumbnailDictionary = character["thumbnail"] as? [AnyHashable: Any],
              let thumbnailURL = thumbnailDictionary["path"] as? String,
              let thumbnailExtension = thumbnailDictionary["extension"] as? String else {
            print("oops. missing character data")
            continue
        }
        let characterEntry = HeroListItem(id: String(id), name: name, thumbnailURL: "\(thumbnailURL).\(thumbnailExtension)")
        characters.append(characterEntry)
    }
    
    return characters
}
