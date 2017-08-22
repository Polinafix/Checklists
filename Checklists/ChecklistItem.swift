//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Polina Fiksson on 08/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation

//serves to combine the text and the checked variables into one object
//NSObject offers a bunch of useful functionality that standard Swift objects don’t have.
//Building ChecklistItem on top of NSObject is enough to make it satisfy the
//“equatable” requirement.

//If you want to use the NSCoder system on an object, the
//object needs to implement the NSCoding protocol

class ChecklistItem:NSObject, NSCoding{
    var text =  ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    //ChecklistItem should save an object named “Text” that contains the value of the instance variable text, and an object named “Checked” that contains the value of the variable checked
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    //creating objects by loading – or decoding – them from a plist file
    //the method for unfreezing the objects from the file
    //take objects from the NSCoder’s decoder object and put their values inside your own properties
    required init?(coder aDecoder: NSCoder) {
        super.init()
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
    }
    
    override init(){
        super.init()
    }
}
