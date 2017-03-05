//
//  AppDataMart.swift
//  FoodEx
//
//  Created by Nana on 2/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

// A Singleton App Globals that provides data throughout the app
struct AppDataMart {

    // Singleton Type property
    static let shared = AppDataMart()

    private let appDataMart : [String:Any]

    var registeredUsers : Dictionary<String, String>? {
        return appDataMart["RegisteredUsers"] as? Dictionary<String, String>
    }

    var cuisines : Array<String>? {
        return appDataMart["Cuisines"] as? Array<String>
    }

    var restaurantsSynopsis : [Dictionary<String, String>]? {
        let restaurants = appDataMart["Restaurants"] as? [Dictionary<String, Any>]

        var restaurantsSynopsis = [Dictionary<String, String>]()
        
        restaurants?.forEach({ (element) in

            var elementSynopsis = element
            elementSynopsis.removeValue(forKey: "Menu")

            if let newElement = elementSynopsis as? Dictionary<String, String> {
                restaurantsSynopsis.append(newElement)
            }
        })

        return restaurantsSynopsis
    }

    var restaurants : [Dictionary<String, Any>]? {
        return appDataMart["Restaurants"] as? [Dictionary<String, Any>]
    }

    var restaurantsLastSeen: [Dictionary<String, String>]? {
        // TDO: This should be extracted from UserDefaults instead
        return Array(restaurantsSynopsis!.prefix(through: 1))
    }

    var orderHistory: Array<OrderDetails>? {

        let orderHistory = UserDefaults.standard.array(forKey: "OrderHistory")

        // TDO: Need to extract Order History and create the model
        if let orderHistory = orderHistory as? Array<OrderDetails> {
            return orderHistory
        } else {

            let stubOrder1 = OrderDetails(title: "Nightout Dinner", reference: "2-143-2358", date: "March 3, 2017", menuItems: [MenuItem(name: "Seasoned Curly Fries", details: "Potatoes Prepared in Vegetable Oil (Canola Oil, Corn Oil, Soybean Oil, Hydrogenated Soybean Oil) and Salt", price: 2.29, image: "JITB_Curly.png", restaurantName: "Jack in the Box"), MenuItem(name: "Cheeseburger", details: "100% beef patty, regular bun, pasteurized process american cheese, ketchup, mustard, pickle slices, onions", price: 1.00, image: "McD_Cheseburger.png", restaurantName: "McDonald's")])

            let stubOrder2 = OrderDetails(title: "Weekend Lunch", reference: "2-237-8453", date: "March 4, 2017", menuItems: [MenuItem(name: "Cheesy Nachos", details: "Crisp, freshly prepared tortilla chips covered in warm nacho cheese sauce.", price: 3.59, image: "TB_Nacho.png", restaurantName: "Taco Bell"), MenuItem(name: "Burrito Bowl", details: "Vegetarian, Chicken, Steak", price: 7.50, image: "Chipotle_BB.png", restaurantName: "Chipotle")])

            return [stubOrder2,stubOrder1]
        }
    }

    private init() {
        
        let dataMartURL = Bundle.main.url(forResource: "AppDataMart", withExtension: "plist")
        let data = try! Data(contentsOf: dataMartURL!)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)

        // TODO: Error Handling
        appDataMart = (plist as? Dictionary<String, Any>)!
    }

    func menuList(for restaurantName: String) -> [Dictionary<String, String>]? {

        if let matchingRestaurants = restaurants?.filter({ (element) -> Bool in
            return (element["Name"] as! String == restaurantName)
        }) {
            let matchedRestaurant = matchingRestaurants.first
            
            return matchedRestaurant?["Menu"] as? [Dictionary<String, String>]
        }

        return nil
    }
}
