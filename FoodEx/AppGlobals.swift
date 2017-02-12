//
//  AppGlobals.swift
//  FoodEx
//
//  Created by Nana on 2/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct AppGlobals {

    private let appDataMart : [String:Any]

    var registeredUsers : [String:String]? {
        get {
            return appDataMart["RegisteredUsers"] as? [String : String]
        }
    }

    init() {
        let dataMartURL = Bundle.main.url(forResource: "AppDataMart", withExtension: "plist")
        let data = try! Data(contentsOf: dataMartURL!)
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)

        // TODO: Error Handling
        appDataMart = (plist as? [String:Any])!
    }
}
