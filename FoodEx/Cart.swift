//
//  Cart.swift
//  FoodEx
//
//  Created by Divya on 3/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

struct Cart {

    var title: String?
    var items: Array<OrderItem>

    var couponIncluded: Bool

    var subTotal: Double {

        if couponIncluded {
            return items.reduce(0, {$0 + $1.totalPrice}) + 40.0
        } else {
            return items.reduce(0, {$0 + $1.totalPrice})
        }
    }

    var formattedSubTotal: String {
        return String(format: "$%.2f", subTotal)
    }

    init(title: String?, items: Array<OrderItem>, couponIncluded: Bool = false) {

        self.title = title
        self.items = items
        self.couponIncluded = couponIncluded
    }

    init(dictionary source: Dictionary<String, Any>) {

        var cartItems = Array<OrderItem>()

        if let cartItemList = source["Items"] as? [Dictionary<String, Any>] {

            for cartItem in cartItemList {

                if let element = OrderItem(dictionary: cartItem) {
                    cartItems.append(element)
                }
            }
        }

        if let couponIncluded = source["Coupon"] as? Bool {
            self.init(title: source["Title"] as? String, items: cartItems, couponIncluded: couponIncluded)
        } else {
            self.init(title: source["Title"] as? String, items: cartItems)
        }
    }


    func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dict = Dictionary<String, Any>()

        if let title = self.title {
            dict.updateValue(title, forKey: "Title")
        }

        dict.updateValue(self.couponIncluded, forKey: "Coupon")

        var itemDicts = [Dictionary<String, Any>]()

        for item in items {
            itemDicts.append(item.dictionaryRepresentation())
        }

        dict.updateValue(itemDicts, forKey: "Items")
        
        return dict
    }

    mutating func add(item: OrderItem) -> Void {

        items.append(item)
    }

    mutating func removeItem(at index: Int) -> Void {

        if index < items.count {
            items.remove(at: index)
        }
    }

    mutating func remove(item: OrderItem) -> Void {

        if let existingIndex = items.index(where: { (element) -> Bool in
            return (element.name == item.name) && (element.restaurantName == item.restaurantName)
        }) {
            items.remove(at: existingIndex)
        }
    }

}
