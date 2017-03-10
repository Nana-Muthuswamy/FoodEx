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

    var restaurants: Array<Restaurant>
    var cart: Cart

    private let appDataMart: [String:Any]

    var registeredUsers: Dictionary<String, String>? {
        return appDataMart["RegisteredUsers"] as? Dictionary<String, String>
    }

    var cuisines: Array<String> {
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

        var orderHistory = Array<Order>()

        if let orderHistoryList = UserDefaults.standard.array(forKey: "OrderHistory") as? [Dictionary<String, Any>] {

            for anOrderDict in orderHistoryList {
                orderHistory.append(Order(dictionary: anOrderDict))
            }
        }

        return orderHistory
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

        if let savedCart = UserDefaults.standard.dictionary(forKey: "SavedCart") {
            cart = Cart(dictionary: savedCart)
        } else {
            cart = Cart(title: nil, items: Array<CartItem>())
        }
    }

    func setLastViewedRestaurant(_ restaurant: Restaurant) -> Void {

        var newViewList: [Dictionary<String, Any>]

        if let savedViewList = UserDefaults.standard.array(forKey: "LastViewedRestaurants") as? [Dictionary<String, Any>] {

            newViewList = savedViewList

            if let existingIndex = savedViewList.index(where: { (element) -> Bool in
                return element["Name"] as! String == restaurant.name
            }) {
                newViewList.remove(at: existingIndex)
            }

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

    func saveOrder(_ newOrder: Order) -> Void {

        var newOrderList: [Dictionary<String, Any>]

        if let savedOrderList = UserDefaults.standard.array(forKey: "OrderHistory") as? [Dictionary<String, Any>] {

            newOrderList = savedOrderList

            newOrderList.insert(newOrder.dictionaryRepresentation(), at: 0)

            // Store only the last 10 orders
            if newOrderList.count > 10 {
                newOrderList = Array(newOrderList.prefix(upTo: 10))
            }

        } else {
            newOrderList = [newOrder.dictionaryRepresentation()]
        }

        UserDefaults.standard.set(newOrderList, forKey: "OrderHistory")

        // Wipe off the Cart
        cart = Cart(title: nil, items: Array<CartItem>())
    }

}
