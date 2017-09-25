//
//  Checklist.swift
//  Checklists
//
//  Created by Polina Fiksson on 14/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    /*
     It does the same thing as init(name, iconName) but saves you from having to type iconName: "No Icon" whenever you want to use it. */
    convenience init(name:String) {
        self.init(name: name, iconName: "No Icon")
    }
    //designated-main initializer
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
/*You asked NSKeyedArchiver(in AllListsViewController) to encode the array of items, so
 it not only has to encode the array itself but also each ChecklistItem object inside that array.
 NSKeyedArchiver knows how to encode an Array object but it doesn’t know anything
 about ChecklistItem.*/
    
    
    //take objects from the NSCoder’s decoder object and put their values inside your own properties
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey:"IconName") as! String
        super.init()
    }
    /* a ChecklistItem should save an object named “Name” that
     contains the value of the instance variable name, and an object named “Items”.*/
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey:"IconName")
    }

}
