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
class ChecklistItem:NSObject{
    var text =  ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
