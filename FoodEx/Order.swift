//
//  Order.swift
//  FoodEx
//
//  Created by Nana on 3/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct Order {

    let reference: String
    let title: String
    let date: String
    var items: Array<OrderItem>

    var couponIncluded: Bool

    var summary: String {
        return items.map{$0.name}.joined(separator:", ")
    }

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

    let deliveryCharge: Double

    var formattedDeliveryCharge: String {
        return String(format: "$%.2f", deliveryCharge)
    }

    var tax: Double {
        return (subTotal * 0.0875)
    }

    var formattedTax: String {
        return String(format: "$%.2f", tax)
    }

    var grandTotal: Double {
        return subTotal + tax + deliveryCharge
    }

    var formattedGrandTotal: String {
        return String(format: "$%.2f", grandTotal)
    }

    init(reference: String?, title: String?, date: String?, items: Array<OrderItem>, deliveryCharge: Double, couponIncluded: Bool = false) {

        if let orderRef = reference {
            self.reference = orderRef
        } else {
            self.reference = Order.generateOrderNumber()
        }

        if let orderTitle = title {
            self.title = orderTitle
        } else {
            self.title = ""
        }

        if let orderDate = date {
            self.date = orderDate
        } else {

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMdYYYY")

            self.date = dateFormatter.string(from: Date())
        }

        self.items = items

        self.deliveryCharge = deliveryCharge

        self.couponIncluded = couponIncluded
    }

    init(dictionary source: Dictionary<String, Any>) {

        var orderItems = Array<OrderItem>()

        if let orderItemList = source["Items"] as? [Dictionary<String, Any>] {

            for orderItem in orderItemList {

                if let element = OrderItem(dictionary: orderItem) {
                    orderItems.append(element)
                }
            }
        }

        if let couponIncluded = source["Coupon"] as? Bool {
            self.init(reference: source["Reference"] as? String, title: source["Title"] as? String, date: source["Date"] as? String, items: orderItems, deliveryCharge: source["DeliveryCharge"] as! Double, couponIncluded: couponIncluded)
        } else {
            self.init(reference: source["Reference"] as? String, title: source["Title"] as? String, date: source["Date"] as? String, items: orderItems, deliveryCharge: source["DeliveryCharge"] as! Double)
        }
    }

    init?(cart: Cart, deliveryCharge: Double) {

        guard cart.items.count > 0 else {
            return nil
        }

        var orderItems = Array<OrderItem>()

        for item in cart.items {

            if let orderItem = OrderItem(dictionary: item.dictionaryRepresentation()) {
                orderItems.append(orderItem)
            }
        }

        self.init(reference: nil, title: cart.title, date: nil, items: orderItems, deliveryCharge: deliveryCharge, couponIncluded: cart.couponIncluded)
    }

    func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dict = Dictionary<String, Any>()

        dict.updateValue(reference, forKey: "Reference")
        dict.updateValue(title, forKey: "Title")
        dict.updateValue(date, forKey: "Date")

        var itemDicts = [Dictionary<String, Any>]()

        for item in items {
            itemDicts.append(item.dictionaryRepresentation())
        }

        dict.updateValue(itemDicts, forKey: "Items")
        dict.updateValue(deliveryCharge, forKey: "DeliveryCharge")
        dict.updateValue(couponIncluded, forKey: "Coupon")
        
        return dict
    }

    static func generateOrderNumber() -> String {

        func transform(_ source: Double) -> Int {

            let a = 62.0
            let b = 59.0
            let c = 803.0

            return Int(((source * b) + c) / a)
        }

        var firstComponent = Double(arc4random())
        firstComponent.formTruncatingRemainder(dividingBy: 1000)

        var secondComponent = Double(arc4random())
        secondComponent.formTruncatingRemainder(dividingBy: 1000)

        return "F\(transform(firstComponent))\(transform(secondComponent))"
    }
}

class OrderItem: MenuItem {

    let restaurantName: String

    var quantity: Int = 1

    var formattedQuantity: String {
        return String(format: "x %d", quantity)
    }

    var totalPrice: Double {
        return price * Double(quantity)
    }

    var formattedTotalPrice: String {
        return String(format: "$%.2f", totalPrice)
    }

    init(name: String, price: Double, details: String?, imageName: String?, restaurantName: String, quantity: Int?) {

        if let itemQuantity = quantity {
            self.quantity = itemQuantity
        }

        self.restaurantName = restaurantName

        super.init(name: name, price: price, details: details, imageName: imageName)
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

        dictRepresentation.updateValue(self.restaurantName, forKey: "RestaurantName")
        dictRepresentation.updateValue(self.quantity, forKey: "Quantity")

        return dictRepresentation
    }
}
