//
//  MenuItem.swift
//  FoodEx
//
//  Created by Divya on 3/5/17.
//  Copyright © 2017 Apple. All rights reserved.
//

// Choosing "class" data structure for MenuItem as this needs to be extensible
class MenuItem {
    let name: String
    let details: String
    let price: Double
    let imageName: String

    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }

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
        guard let menuName = source["Name"] as? String, let menuPrice = source["Price"] as? Double else {
            return nil
        }

        self.init(name:menuName, price:menuPrice, details:source["Details"] as? String, imageName:source["Image"] as? String)
    }

    func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dictRepresentation = Dictionary<String, Any>()

        dictRepresentation.updateValue(self.name, forKey: "Name")
        dictRepresentation.updateValue(self.details, forKey: "Details")
        dictRepresentation.updateValue(self.price, forKey: "Price")
        dictRepresentation.updateValue(self.imageName, forKey: "Image")

        return dictRepresentation
    }

}
