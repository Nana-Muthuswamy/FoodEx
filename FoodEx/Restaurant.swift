//
//  Restaurant.swift
//  FoodEx
//
//  Created by Nana on 3/5/17.
//  Copyright © 2017 Apple. All rights reserved.
//

struct Restaurant {

    let name: String
    let description: String
    let distance: Double
    let imageName: String
    let cuisine: String
    let address: String
    let reviewRating: Int
    let costRating: Int
    let operationHours: String
    let menu: Array<MenuItem>

    var formattedDistance: String {
        return String(format: "%.2f mi.", distance)
    }

    init(name: String, description: String?, distance: Double, imageName: String?, cuisine: String, address: String, reviewRating: Int?, costRating: Int?, operationHours: String?, menu: Array<MenuItem>) {

        self.name = name
        self.distance = distance
        self.cuisine = cuisine
        self.address = address

        if let restaurantDesc = description {
            self.description = restaurantDesc
        } else {
            self.description = "Description not available."
        }

        if let restaurantImageName = imageName {
            self.imageName = restaurantImageName
        } else {
            self.imageName = ""
        }

        if let reviewRating = reviewRating {
            self.reviewRating = min(max(reviewRating, 0), 5)
        } else {
            self.reviewRating = 0
        }

        if let costRating = costRating {
            self.costRating = min(max(costRating, 0), 5)
        } else {
            self.costRating = 0
        }

        if let restaurantOperationHours = operationHours {
            self.operationHours = restaurantOperationHours
        } else {
            self.operationHours = "Operation hours not available."
        }

        self.menu = menu
    }


    init?(dictionary source: Dictionary<String, Any>) {

        guard let theName = source["Name"] as? String, let cuisineType = source["Cuisine"] as? String, let theDistance = source["Distance"] as? Double, let theAddress = source["Address"] as? String else {

            return nil
        }

        var menuList = Array<MenuItem>()

        if let theMenu = source["Menu"] as? [Dictionary<String, Any>] {

            for menuItemDict in theMenu {
                if let menuItem = MenuItem(dictionary: menuItemDict) {
                    menuList.append(menuItem)
                }
            }
        }

        self.init(name: theName, description: source["Description"] as? String, distance: theDistance, imageName: source["Image"] as? String, cuisine: cuisineType, address: theAddress, reviewRating: Int(source["Reviews"] as! Int), costRating: Int(source["Cost"] as! Int), operationHours: source["OperationHours"] as? String, menu: menuList)
    }

    func dictionaryRepresentation() -> Dictionary<String, Any> {

        var dict = Dictionary<String, Any>()

        dict.updateValue(name, forKey: "Name")
        dict.updateValue(description, forKey: "Description")
        dict.updateValue(distance, forKey: "Distance")
        dict.updateValue(imageName, forKey: "Image")
        dict.updateValue(cuisine, forKey: "Cuisine")
        dict.updateValue(address, forKey: "Address")
        dict.updateValue(reviewRating, forKey: "Reviews")
        dict.updateValue(costRating, forKey: "Cost")
        dict.updateValue(operationHours, forKey: "OperationHours")

        var menuDicts = [Dictionary<String, Any>]()

        for menuItem in menu {
            menuDicts.append(menuItem.dictionaryRepresentation())
        }

        dict.updateValue(menuDicts, forKey: "Menu")

        return dict
    }
}
