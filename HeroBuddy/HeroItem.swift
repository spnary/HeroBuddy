//
//  HeroListItem.swift
//  HeroBuddy
//
//  Created by Stephen Nary on 9/20/21.
//

import UIKit
import CoreData

struct HeroItem {
    let id: String
    let name: String
    let description: String
    let thumbnailURL: String
    var thumbnail: UIImage?
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let heroRequest = NSFetchRequest<NSManagedObject>(entityName: "Hero")
        let predicate = NSPredicate(format: "id == %@", id)
        heroRequest.predicate = predicate
        var heroEntities: [NSManagedObject] = []
        do {
            heroEntities = try managedContext.fetch(heroRequest)
            
        } catch {
            print("error updating hero: \(error)")
        }
        let hero: NSManagedObject
        if let firstEntity = heroEntities.first  {
            hero = firstEntity
        } else {
            guard let heroEntity = NSEntityDescription.entity(forEntityName: "Hero", in: managedContext) else { return }
            hero = NSManagedObject(entity: heroEntity, insertInto: managedContext)
        }
        hero.setValue(id, forKey: "id")
        hero.setValue(name, forKey: "name")
        hero.setValue(description, forKey: "heroDescription")
        hero.setValue(thumbnailURL, forKey: "thumbnailURL")
        if let thumbnailData = thumbnail?.pngData() {
            hero.setValue(thumbnailData, forKey: "thumbnail")
        }
        
        do {
            try managedContext.save()
        } catch {
            print("error saving hero: \(error.localizedDescription)")
        }
    }
}

func heroItemsFromJsonObject(_ object: [AnyHashable: Any]) -> [HeroItem] {
    guard let characterData = object["data"] as? [AnyHashable: Any] else {
        print("Missing data")
        return []
    }
    guard let characterResults = characterData["results"] as? [Any] else {
        print("missing results")
        return []
    }
    var characters: [HeroItem] = []
    for character in characterResults {
        guard let character = character as? [AnyHashable: Any],
              let id = character["id"] as? Int,
              let name = character["name"] as? String,
              let description = character["description"] as? String,
              let thumbnailDictionary = character["thumbnail"] as? [AnyHashable: Any],
              let thumbnailURL = thumbnailDictionary["path"] as? String,
              let thumbnailExtension = thumbnailDictionary["extension"] as? String else {
            print("oops. missing character data")
            continue
        }
        let characterEntry = HeroItem(id: String(id), name: name, description: description, thumbnailURL: "\(thumbnailURL).\(thumbnailExtension)")
        characters.append(characterEntry)
    }
    
    return characters
}

func heroItemFrom(_ managedObject: NSManagedObject) -> HeroItem? {
    guard let id = managedObject.value(forKey: "id") as? String,
          let name = managedObject.value(forKey: "name") as? String,
          let description = managedObject.value(forKey: "heroDescription") as? String,
          let thumbnailURL = managedObject.value(forKey: "thumbnailURL") as? String else { return nil }
    var thumbnail: UIImage?
    if let thumbnailData = managedObject.value(forKey: "thumbnail") as? Data {
        thumbnail = UIImage(data: thumbnailData)
    }
    
    return HeroItem(id: id, name: name, description: description, thumbnailURL: thumbnailURL, thumbnail: thumbnail)
}
