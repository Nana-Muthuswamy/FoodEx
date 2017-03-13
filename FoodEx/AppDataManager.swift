//
//  AppDataManager.swift
//  FoodEx
//
//  Created by Nana on 2/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

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
