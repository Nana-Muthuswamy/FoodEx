//
//  Order.swift
//  FoodEx
//
//  Created by Nana on 3/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

struct Order {
    var title: String
    var reference: String
    let date: String
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
}

class OrderItem: MenuItem {

    let restaurantName: String

    init(name: String, details: String, price: Double, image: String, restaurant: String) {

        restaurantName = restaurant

        super.init(name: name, details: details, price: price, image: image)
    }
}
