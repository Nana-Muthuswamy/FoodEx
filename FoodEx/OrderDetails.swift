//
//  OrderDetails.swift
//  FoodEx
//
//  Created by Nana on 3/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

struct OrderDetails {
    var title: String
    var reference: String
    let date: String
    var menuItems: Array<MenuItem>

    var menuSummary: String {
        return menuItems.map{$0.name}.joined(separator:", ")
    }

    var subTotal: Double {
        return menuItems.reduce(0, {$0 + $1.price})
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

struct MenuItem {
    let name: String
    let details: String
    let price: Double
    let image: String
    let restaurantName: String

    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
}
