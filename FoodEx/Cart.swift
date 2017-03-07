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

    init(title: String?, items: Array<CartItem>) {

        self.title = title
        self.items = items
    }

    init(dictionary source: Dictionary<String, Any>) {

        var cartItems = Array<CartItem>()

        if let cartItemList = source["Items"] as? [Dictionary<String, Any>] {

            for cartItem in cartItemList {

                if let element = CartItem(dictionary: cartItem) {
                    cartItems.append(element)
                }
            }
        }

        self.init(title: source["Title"] as? String, items: cartItems)
    }


    func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dict = Dictionary<String, Any>()

        if let title = self.title {
            dict.updateValue(title, forKey: "Title")
        }

        var itemDicts = [Dictionary<String, Any>]()

        for item in items {
            itemDicts.append(item.dictionaryRepresentation())
        }

        dict.updateValue(itemDicts, forKey: "Items")
        
        return dict
    }
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

    override func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dictRepresentation = super.dictionaryRepresentation()

        dictRepresentation.updateValue(self.quantity, forKey: "Quantity")

        return dictRepresentation
    }
}
