//
//  Cart.swift
//  FoodEx
//
//  Created by Nana on 3/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

struct Cart {

    var title: String?
    var items: Array<CartItem>
    
}

class CartItem: OrderItem {

    var quantity: Int = 1

    init(name: String, price: Double, details: String?, imageName: String?, restaurantName: String, quantity: Int) {

        self.quantity = quantity

        super.init(name: name, price: price, details: details, imageName: imageName, restaurantName: restaurantName)
    }

    convenience init?(dictionary source:Dictionary<String, Any>) {

        // Cannot create OrderItem without Restaurant Name, Item Name and Price
        guard let restaurantName = source["RestaurantName"] as? String, let menuName = source["Name"] as? String, let menuPricestr = source["Price"] as? String, let menuPrice = Double(menuPricestr) else {
            return nil
        }

        self.init(name: menuName, price: menuPrice, details: source["Details"] as? String, imageName: source["Image"] as? String, restaurantName: restaurantName, quantity: source["Quantity"] as! Int)
    }
}
