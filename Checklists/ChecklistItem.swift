//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Polina Fiksson on 08/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation

//serves to combine the text and the checked variables into one object

class ChecklistItem{
    var text =  ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
