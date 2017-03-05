//
//  Restaurant.swift
//  FoodEx
//
//  Created by Nana on 3/5/17.
//  Copyright © 2017 Apple. All rights reserved.
//

struct Restaurant {

}

// Choosing "class" for MenuItem as this needs to be extensible
class MenuItem {
    let name: String
    let details: String
    let price: Double
    let image: String

    init(name: String, details: String, price: Double, image: String) {

        self.name = name
        self.details = details
        self.price = price
        self.image = image
    }

    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
}
