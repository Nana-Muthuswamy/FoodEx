//
//  AppDataMart.swift
//  FoodEx
//
//  Created by Nana on 2/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

// A Singleton Data Mart that extacts data from DataMart.plist and provides data for all controllers
struct AppDataMart {

    // Singleton Type property
    static let shared = AppDataMart()

    var restaurants : Array<Restaurant>

    private let appDataMart : [String:Any]

    var registeredUsers : Dictionary<String, String>? {
        return appDataMart["RegisteredUsers"] as? Dictionary<String, String>
    }

    var cuisines : Array<String> {
        return appDataMart["Cuisines"] as! Array<String>
    }

    var restaurantsLastViewed: Array<Restaurant> {

        var restaurantsLastViewed = Array<Restaurant>()

        if let viewHistoryList = UserDefaults.standard.array(forKey: "LastViewedRestaurants") as? [Dictionary<String, Any>] {

            for aRestaurantDict in viewHistoryList {
                if let element = Restaurant(dictionary: aRestaurantDict) {
                    restaurantsLastViewed.append(element)
                }
            }
        }

        return restaurantsLastViewed
    }

    var orderHistory: Array<Order> {

        let orderHistory = UserDefaults.standard.array(forKey: "OrderHistory")

        // TDO: Need to extract Order History and create the model
        if let orderHistory = orderHistory as? Array<Order> {
            return orderHistory
        } else {

            let stubOrder2 = Order(reference: "2-143-2358",title: "Nightout Dinner", date: "March 3, 2017", status: OrderStatus.completed, items: [OrderItem(name: "Seasoned Curly Fries", price: 2.29, details: "Potatoes Prepared in Vegetable Oil (Canola Oil, Corn Oil, Soybean Oil, Hydrogenated Soybean Oil) and Salt", imageName: "JITB_Curly.png", restaurantName: "Jack in the Box"), OrderItem(name: "Cheeseburger", price: 1.00, details: "100% beef patty, regular bun, pasteurized process american cheese, ketchup, mustard, pickle slices, onions", imageName: "McD_Cheseburger.png", restaurantName: "McDonald's")])


            let stubOrder1 = Order(reference: "2-237-8453", title: "Weekend Lunch", date: "March 4, 2017", status: OrderStatus.completed, items: [OrderItem(name: "Cheesy Nachos", price: 3.59, details: "Crisp, freshly prepared tortilla chips covered in warm nacho cheese sauce.", imageName: "TB_Nacho.png", restaurantName: "Taco Bell"), OrderItem(name: "Burrito Bowl", price: 7.50, details: "Vegetarian, Chicken, Steak", imageName: "Chipotle_BB.png", restaurantName: "Chipotle")])


            return [stubOrder1,stubOrder2]
        }
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

    func setLastViewedRestaurant(_ restaurant: Restaurant) -> Void {

        var newViewList: [Dictionary<String, Any>]

        if let savedViewList = UserDefaults.standard.array(forKey: "LastViewedRestaurants") as? [Dictionary<String, Any>] {

            newViewList = savedViewList
            newViewList.insert(restaurant.dictionaryRepresentation(), at: 0)

            // Store only the last 3 viewed restaurants
            if newViewList.count > 3 {
                newViewList = Array(newViewList.prefix(upTo: 3))
            }

        } else {
            newViewList = [restaurant.dictionaryRepresentation()]
        }

        UserDefaults.standard.set(newViewList, forKey: "LastViewedRestaurants")
    }
}
