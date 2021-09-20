//
//  DataRequester.swift
//  HeroBuddy
//
//  Created by Stephen Nary on 9/20/21.
//

import Foundation
import CryptoKit

class DataRequester {
    class func apiTest() {
        let session = URLSession(configuration: .default)
        var components = URLComponents(string: "https://gateway.marvel.com/v1/public/characters")
        let tsValue = String(Date().timeIntervalSince1970)
        let apiKeyValue = "3bed9d8e975c6b6c88b670885a9bad73"
        let hashString = "\(tsValue)e3b6a543c2fe95b3d83e73cfdb1c5acfd462cfce\(apiKeyValue)"
        let hashValue  = Insecure.MD5.hash(data: hashString.data(using: .utf8)!).map {String(format: "%02x", $0)}.joined()
        let tsQueryItem = URLQueryItem(name: "ts", value: tsValue)
        let apiKeyQueryItem = URLQueryItem(name: "apikey", value: apiKeyValue)
        let hashQueryItem = URLQueryItem(name: "hash", value: hashValue)
        components?.queryItems = [tsQueryItem, apiKeyQueryItem, hashQueryItem, URLQueryItem(name: "limit", value: "2")]
        let requestURL: URL = (components?.url)!
        let request = URLRequest(url: requestURL)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            print("Error: \(error)")
            print("response: \(response)")
            print("data: \(String(data: data!, encoding: .utf8))")
        }
        dataTask.resume()
    }
}
