//
//  User.swift
//  FoodEx
//
//  Created by Nana on 3/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct User {

    let name: String
    let email: String

    var cart: Cart

    var restaurantsLastViewed: Array<Restaurant>

    var orderHistory: Array<Order>

    init(name: String, email: String?) {

        self.name = name
        
        if let userEmail = email {
            self.email = userEmail
        } else {
            self.email = "drajagopal@scu.edu"
        }

        cart = Cart(title: nil, items: Array<OrderItem>())
        restaurantsLastViewed = Array<Restaurant>()
        orderHistory = Array<Order>()

        if let userDefaults = UserDefaults.standard.dictionary(forKey: name) {

            if let savedCart = userDefaults["SavedCart"] as? Dictionary<String, Any> {
                cart = Cart(dictionary: savedCart)
            }

            if let viewHistoryList = userDefaults["LastViewedRestaurants"] as? [Dictionary<String, Any>] {

                for aRestaurantDict in viewHistoryList {
                    if let element = Restaurant(dictionary: aRestaurantDict) {
                        restaurantsLastViewed.append(element)
                    }
                }
            }

            if let orderHistoryList = userDefaults["OrderHistory"] as? [Dictionary<String, Any>] {

                for anOrderDict in orderHistoryList {
                    orderHistory.append(Order(dictionary: anOrderDict))
                }
            }

        }
    }

    mutating func saveViewedRestaurant(_ restaurant: Restaurant) -> Void {

        if let existingIndex = restaurantsLastViewed.index(where: { (element) -> Bool in
            return (element.name == restaurant.name)
        }) {
            restaurantsLastViewed.remove(at: existingIndex)
        }

        restaurantsLastViewed.insert(restaurant, at: 0)

        // Store only the last 3 viewed restaurants
        if restaurantsLastViewed.count > 3 {
            restaurantsLastViewed = Array(restaurantsLastViewed.prefix(upTo: 3))
        }
    }

    mutating func saveOrder(_ newOrder: Order) -> Void {

        orderHistory.insert(newOrder, at: 0)

        // Store only the last 10 orders
        if orderHistory.count > 10 {
            orderHistory = Array(orderHistory.prefix(upTo: 10))
        }

        // Wipe off the Cart
        cart = Cart(title: nil, items: Array<OrderItem>())
    }

    func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dict = Dictionary<String, Any>()

        // Cart
        if cart.items.count > 0 {
            dict.updateValue(cart.dictionaryRepresentation(), forKey: "SavedCart")
        }

        // RestaurantsLastViewed
        if restaurantsLastViewed.count > 0 {
            var viewHistoryList = [Dictionary<String, Any>]()

            for restaurant in restaurantsLastViewed {
                viewHistoryList.append(restaurant.dictionaryRepresentation())
            }

            dict.updateValue(viewHistoryList, forKey: "LastViewedRestaurants")
        }

        // OrderHistory
        if orderHistory.count > 0 {
            var orderHistoryList = [Dictionary<String, Any>]()

            for order in orderHistory {
                orderHistoryList.append(order.dictionaryRepresentation())
            }

            dict.updateValue(orderHistoryList, forKey: "OrderHistory")
        }
        
        return dict
    }
}
