//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Polina Fiksson on 05/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items:[ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]() // add this line
        
        let row0item = ChecklistItem() // let
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item) // add this line
        
        let row1item = ChecklistItem() // let
        row1item.text = "Brush my teeth"
        row1item.checked = true
        items.append(row1item) // add this line
        
        let row2item = ChecklistItem() // let
        row2item.text = "Learn iOS development"
        row2item.checked = true
        items.append(row2item) // add this line
        
        let row3item = ChecklistItem() // let
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item) // add this line
        
        let row4item = ChecklistItem() // let
        row4item.text = "Eat ice cream"
        row4item.checked = true
        items.append(row4item) // add this line
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }

    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with:item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

