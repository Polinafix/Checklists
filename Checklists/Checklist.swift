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
    
    init(name:String) {
        self.name = name
        super.init()
    }
/*You asked NSKeyedArchiver(in AllListsViewController) to encode the array of items, so
 it not only has to encode the array itself but also each ChecklistItem object inside that array.
 NSKeyedArchiver knows how to encode an Array object but it doesn’t know anything
 about ChecklistItem.*/
    
    
    //take objects from the NSCoder’s decoder object and put their values inside your own properties
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    /* a ChecklistItem should save an object named “Name” that
     contains the value of the instance variable name, and an object named “Items”.*/
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }

}
