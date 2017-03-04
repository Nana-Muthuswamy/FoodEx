//
//  AppGlobals.swift
//  FoodEx
//
//  Created by Nana on 2/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

// A Singleton App Globals that provides data throughout the app
struct AppGlobals {

    // Singleton Type property
    static let shared = AppGlobals()

    private let appDataMart : [String:Any]

    var registeredUsers : [String:String]? {
        return appDataMart["RegisteredUsers"] as? [String : String]
    }

    var cuisines : [String]? {
        return appDataMart["Cuisines"] as? [String]
    }

    var restaurantsSynopsis : [[String:String]]? {
        let restaurants = appDataMart["Restaurants"] as? [[String:Any]]

        var restaurantsSynopsis = [[String:String]]()
        
        restaurants?.forEach({ (element) in

            var elementSynopsis = element
            elementSynopsis.removeValue(forKey: "Menu")

            if let newElement = elementSynopsis as? [String:String] {
                restaurantsSynopsis.append(newElement)
            }
        })

        return restaurantsSynopsis
    }

    var restaurants : [[String:Any]]? {
        return appDataMart["Restaurants"] as? [[String : Any]]
    }

    var restaurantsLastSeen: [[String:String]]? {
        // TDO: This should be extracted from UserDefaults instead
        return Array(restaurantsSynopsis!.prefix(through: 1))
    }

    var orderHistory: [[String:String]]? {

        let orderHistory = UserDefaults.standard.array(forKey: "OrderHistory")

        if let orderHistory = orderHistory as? [[String:String]] {
            return orderHistory
        } else {

            let stubOrderHistory = [["Summary":"Yesterday's Dinner", "ItemDetails":"Seasoned Curly Fries, Cheeseburger.","Total":"$4.22"],["Summary":"Yesterday's Lunch", "ItemDetails":"Cheesy Nachos, Burrito Bowl.","Total":"$13.73"]]

            return stubOrderHistory
        }
    }

    private init() {
        
        let dataMartURL = Bundle.main.url(forResource: "AppDataMart", withExtension: "plist")
        let data = try! Data(contentsOf: dataMartURL!)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)

        // TODO: Error Handling
        appDataMart = (plist as? [String:Any])!
    }

    func menuList(for restaurantName: String) -> [[String:String]]? {

        if let matchingRestaurants = restaurants?.filter({ (element) -> Bool in
            return (element["Name"] as! String == restaurantName)
        }) {
            let matchedRestaurant = matchingRestaurants.first
            
            return matchedRestaurant?["Menu"] as? [[String:String]]
        }

        return nil
    }
}
