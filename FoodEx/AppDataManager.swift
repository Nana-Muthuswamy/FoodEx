//
//  AppDataManager.swift
//  FoodEx
//
//  Created by Divya on 2/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import Stripe

// A Singleton Data Mart that extacts data from DataMart.plist and provides data for all controllers
class AppDataManager {

    // Singleton Type property
    static let shared = AppDataManager()

    // User specific properites
    var user: User!

    // Generic Properties
    var restaurants: Array<Restaurant>

    private let appDataMart: [String:Any]

    var registeredUsers: [Dictionary<String, Any>] {
        return (appDataMart["RegisteredUsers"] as? [Dictionary<String, Any>]) ?? [Dictionary<String, Any>]()
    }

    var cuisines: Array<String> {
        return appDataMart["Cuisines"] as! Array<String>
    }

    private init() {
        
        let dataMartURL = Bundle.main.url(forResource: "AppDataMart", withExtension: "plist")
        let data = try! Data(contentsOf: dataMartURL!)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)

        // TODO: Error Handling
        appDataMart = (plist as? Dictionary<String, Any>)!

        // Extract Restaurants Data
        restaurants = Array<Restaurant>()

        if let restaurantList = appDataMart["Restaurants"] as? [Dictionary<String, Any>] {

            for restaurantDict in restaurantList {

                if let element = Restaurant(dictionary: restaurantDict) {
                    restaurants.append(element)
                }
            }
        }
    }
}

extension AppDataManager {

    func createBackendCharge(sourceID: String, grandTotal: Decimal, completion: @escaping (NSError?) -> Void) -> Void {

        guard let url = URL(string: "https://nanafoodex.herokuapp.com/create_charge") else {

            let error = NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "You must set a backend base URL in Constants.m to create a charge."])
            completion(error)
            return
        }

        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        let body = "source=\(sourceID)&amount=\(grandTotal.description)"

        let session = URLSession(configuration: URLSessionConfiguration.default)

        let task = session.uploadTask(with: request, from: body.data(using: .utf8)) { (data, response, error) in

            var error = error

            let httpResponse = response as! HTTPURLResponse

            if httpResponse.statusCode != 200 {
                error = NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "There was an error connecting to your payment backend."])
            }

            if error == nil {
                completion(nil)
            } else {
                completion(NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: error?.localizedDescription ?? "No Error Description"]))
            }
        }

        task.resume()
    }
    
}
