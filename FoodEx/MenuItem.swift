//
//  MenuItem.swift
//  FoodEx
//
//  Created by Nana on 3/5/17.
//  Copyright © 2017 Apple. All rights reserved.
//

// Choosing "class" data structure for MenuItem as this needs to be extensible
class MenuItem {
    let name: String
    let details: String
    let price: Double
    let imageName: String

    init(name: String, price: Double, details: String?, imageName: String?) {

        self.name = name
        self.price = price

        if let itemDetails = details {
            self.details = itemDetails
        } else {
            self.details = ""
        }

        if let itemImageName = imageName {
            self.imageName = itemImageName
        } else {
            self.imageName = ""
        }
    }

    convenience init?(dictionary source: Dictionary<String, Any>) {

        // Cannot create MenuItem without Name and Price
        guard let menuName = source["Name"] as? String, let menuPricestr = source["Price"] as? String, let menuPrice = Double(menuPricestr) else {
            return nil
        }

        self.init(name:menuName, price:menuPrice, details:source["Details"] as? String, imageName:source["Image"] as? String)
    }

    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
}
