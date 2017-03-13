//
//  User.swift
//  FoodEx
//
//  Created by Nana on 3/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct User {

    let id: String
    let email: String

    let name: Name
    let address: Address

    var cart: Cart
    var restaurantsLastViewed: Array<Restaurant>
    var orderHistory: Array<Order>

    init(id: String, email: String, name: Name, address: Address, cart: Cart, restaurantsLastViewed: Array<Restaurant>, orderHistory: Array<Order>) {

        self.id = id
        self.email = email
        self.name = name
        self.address = address
        self.cart = cart
        self.restaurantsLastViewed = restaurantsLastViewed
        self.orderHistory = orderHistory
    }

    init?(dictionary source: Dictionary<String, Any>) {

        guard let id = source["ID"] as? String, let name = Name(dictionary: source["ContactName"] as? Dictionary<String, String>), let address = Address(dictionary: source["Address"] as? Dictionary<String, String>) else {
            return nil
        }

        var email = "drajagopal@scu.edu"

        if let userEmail = source["Email"] as? String {
            email = userEmail
        }

        var cart = Cart(title: nil, items: Array<OrderItem>())
        var restaurantsLastViewed = Array<Restaurant>()
        var orderHistory = Array<Order>()

        if let userDefaults = UserDefaults.standard.dictionary(forKey: id) {

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

        self.init(id: id, email: email, name: name, address: address, cart: cart, restaurantsLastViewed: restaurantsLastViewed, orderHistory: orderHistory)
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

struct Name {

    let firstName: String
    let lastName: String

    init(firstName: String, lastName: String) {

        self.firstName = firstName
        self.lastName = lastName
    }

    init?(dictionary source: Dictionary<String, String>?) {

        guard let firstName = source?["FirstName"], let lastName = source?["LastName"] else {
            return nil
        }

        self.init(firstName: firstName, lastName: lastName)
    }
}

struct Address {

    let street: String
    let city: String
    let state: String
    let postalCode: String

    init(street: String, city: String, state: String, postalCode: String) {

        self.street = street
        self.city = city
        self.state = state
        self.postalCode = postalCode
    }

    init?(dictionary source: Dictionary<String, String>?) {

        guard let street = source?["Street"], let city = source?["City"], let state = source?["State"], let postalCode = source?["PostalCode"] else {
            return nil
        }

        self.init(street: street, city: city, state: state, postalCode: postalCode)
    }
}
