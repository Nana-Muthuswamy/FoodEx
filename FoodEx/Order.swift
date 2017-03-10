//
//  Order.swift
//  FoodEx
//
//  Created by Nana on 3/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

enum OrderStatus: Int {
    case none
    case pending
    case completed
}

struct Order {

    let reference: String
    let title: String
    let date: String
    var status: OrderStatus
    var items: Array<OrderItem>

    var summary: String {
        return items.map{$0.name}.joined(separator:", ")
    }

    var subTotal: Double {
        return items.reduce(0, {$0 + $1.price})
    }

    var formattedSubTotal: String {
        return String(format: "$%.2f", subTotal)
    }

    var grandTotal: Double {
        return (subTotal * 1.085)
    }

    var formattedGrandTotal: String {
        return String(format: "$%.2f", grandTotal)
    }

    init(reference: String?, title: String?, date: String?, status: OrderStatus?, items: Array<OrderItem>) {

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
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")

            self.date = dateFormatter.string(from: Date())
        }

        if let orderStatus = status {
            self.status = orderStatus
        } else {
            self.status = OrderStatus.init(rawValue:0)!
        }

        self.items = items
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

        self.init(reference: source["Reference"] as? String, title: source["Title"] as? String, date: source["Date"] as? String, status: source["Status"] as? OrderStatus, items: orderItems)
    }

    init?(cart: Cart) {

        guard cart.items.count > 0 else {
            return nil
        }

        var orderItems = Array<OrderItem>()

        for item in cart.items {

            if let orderItem = OrderItem(dictionary: item.dictionaryRepresentation()) {
                orderItems.append(orderItem)
            }
        }

        self.init(reference: nil, title: cart.title, date: nil, status: OrderStatus.init(rawValue:2), items: orderItems)
    }

    func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dict = Dictionary<String, Any>()

        dict.updateValue(reference, forKey: "Reference")
        dict.updateValue(title, forKey: "Title")
        dict.updateValue(date, forKey: "Date")
        dict.updateValue(status.rawValue, forKey: "Status")

        var itemDicts = [Dictionary<String, Any>]()

        for item in items {
            itemDicts.append(item.dictionaryRepresentation())
        }

        dict.updateValue(itemDicts, forKey: "Items")
        
        return dict
    }

    static func generateOrderNumber() -> String {

        func transform(source: Int) -> Int {

            var destination: Int

            let a = 62
            let b = 59
            let c = 803

            destination = ((source * b) + c) / a

            return destination
        }

        return "F-\(transform(source: Int(arc4random())))-\(transform(source: Int(arc4random())))"
    }
}

class OrderItem: MenuItem {

    let restaurantName: String

    init(name: String, price: Double, details: String?, imageName: String?, restaurantName: String) {

        self.restaurantName = restaurantName

        super.init(name: name, price: price, details: details, imageName: imageName)
    }

    convenience init?(dictionary source:Dictionary<String, Any>) {

        // Cannot create OrderItem without Restaurant Name, Item Name and Price
        guard let restaurantName = source["RestaurantName"] as? String, let menuName = source["Name"] as? String, let menuPrice = source["Price"] as? Double else {
            return nil
        }

        self.init(name: menuName, price: menuPrice, details: source["Details"] as? String, imageName: source["Image"] as? String, restaurantName: restaurantName)
    }

    override func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dictRepresentation = super.dictionaryRepresentation()

        dictRepresentation.updateValue(self.restaurantName, forKey: "RestaurantName")

        return dictRepresentation
    }
}
