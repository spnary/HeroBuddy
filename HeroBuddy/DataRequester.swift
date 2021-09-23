//
//  DataRequester.swift
//  HeroBuddy
//
//  Created by Stephen Nary on 9/20/21.
//

import UIKit
import CryptoKit
import CoreData

class DataRequester {
    enum RequestError: Error {
        case invalidURL
        case invalidResponse
        case invalidImage
    }
    let baseURLString = "https://gateway.marvel.com"
    let session = URLSession(configuration: .default)
    
    
    func getCharacters(completion: @escaping (([HeroItem]?, Error?) -> Void)) {
        if let heroItems = getCharactersFromCoreData(), !heroItems.isEmpty {
            completion(heroItems, nil)
        } else {
            getCharactersFromWeb() { response, error in
                guard let response = response else {
                    completion(nil, error)
                    return
                }
                let heroList = heroItemsFromJsonObject(response)
                completion(heroList, nil)
            }
        }
    }
    
    private func getCharactersFromCoreData() -> [HeroItem]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let heroRequest = NSFetchRequest<NSManagedObject>(entityName: "Hero")
        var heroItems: [HeroItem] = []
        do {
            let heroEntities = try managedContext.fetch(heroRequest)
            for entity in heroEntities {
                guard let heroItem = heroItemFrom(entity) else { continue }
                heroItems.append(heroItem)
            }
            return heroItems
        } catch {
            print("error fetching heros from core data: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    private func getCharactersFromWeb(completion: @escaping (([AnyHashable: Any]?, Error?) -> Void)){
        var components = URLComponents(string: baseURLString.appending("/v1/public/characters"))
        let limitQueryItem = URLQueryItem(name: "limit", value: "20")
        let queryItems = DataRequester.authQueryItems() + [limitQueryItem]
        components?.queryItems = queryItems
        guard let url = components?.url else {
            completion(nil, RequestError.invalidURL)
            return
        }
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, RequestError.invalidResponse)
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data) as? [AnyHashable: Any]
                completion(jsonData, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        dataTask.resume()
    }
    
    func getThumbnail(url: URL, completion: @escaping ((UIImage?, Error?) -> Void)) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = DataRequester.authQueryItems()
        guard let imageURL = components?.url else {
            completion(nil, RequestError.invalidURL)
            return
        }
        let request = URLRequest(url: imageURL)
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, RequestError.invalidResponse)
                return
            }
            guard let image = UIImage(data: data) else {
                completion(nil, RequestError.invalidImage)
                return
            }
            completion(image, nil)
        }
        dataTask.resume()
    }
    
    class func authQueryItems() -> [URLQueryItem] {
        let tsValue = String(Date().timeIntervalSince1970)
        let apiKeyValue = "3bed9d8e975c6b6c88b670885a9bad73"
        let hashString = "\(tsValue)e3b6a543c2fe95b3d83e73cfdb1c5acfd462cfce\(apiKeyValue)"
        let hashValue  = Insecure.MD5.hash(data: hashString.data(using: .utf8)!).map {String(format: "%02x", $0)}.joined()
        let tsQueryItem = URLQueryItem(name: "ts", value: tsValue)
        let apiKeyQueryItem = URLQueryItem(name: "apikey", value: apiKeyValue)
        let hashQueryItem = URLQueryItem(name: "hash", value: hashValue)
        return [tsQueryItem, apiKeyQueryItem, hashQueryItem]
    }
}
