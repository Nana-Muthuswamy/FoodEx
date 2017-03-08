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

    mutating func add(item: CartItem) -> Void {

        items.append(item)
    }

    mutating func removeItem(at index: Int) -> Void {

        if index < items.count {
            items.remove(at: index)
        }
    }

    mutating func remove(item: CartItem) -> Void {

        if let existingIndex = items.index(where: { (element) -> Bool in
            return (element.name == item.name) && (element.restaurantName == item.restaurantName)
        }) {
            items.remove(at: existingIndex)
        }
    }

}

class CartItem: OrderItem {

    var quantity: Int = 1

    override var formattedPrice: String {
        return String(format: "$%.2f", price * Double(quantity))
    }

    init(name: String, price: Double, details: String?, imageName: String?, restaurantName: String, quantity: Int?) {

        if let itemQuantity = quantity {
            self.quantity = itemQuantity
        }

        super.init(name: name, price: price, details: details, imageName: imageName, restaurantName: restaurantName)
    }

    convenience init?(dictionary source:Dictionary<String, Any>) {

        // Cannot create OrderItem without Restaurant Name, Item Name and Price
        guard let restaurantName = source["RestaurantName"] as? String, let menuName = source["Name"] as? String, let menuPrice = source["Price"] as? Double else {
            return nil
        }

        self.init(name: menuName, price: menuPrice, details: source["Details"] as? String, imageName: source["Image"] as? String, restaurantName: restaurantName, quantity: source["Quantity"] as? Int)
    }

    convenience init?(from restaurant: Restaurant, itemIndex index: Int) {

        guard index < restaurant.menu.count else {
            return nil
        }

        let source = restaurant.menu[index]

        self.init(name: source.name, price: source.price, details: source.details, imageName: source.imageName, restaurantName: restaurant.name, quantity: 1)
    }

    override func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dictRepresentation = super.dictionaryRepresentation()

        dictRepresentation.updateValue(self.quantity, forKey: "Quantity")

        return dictRepresentation
    }

}
