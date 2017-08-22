//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Polina Fiksson on 05/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist:Checklist!
    //// This declares that items will hold an array of ChecklistItem objects
    // but it does not actually create that array.
    // At this point, items does not have a value yet.
    var items:[ChecklistItem]
    
//    The init method is called by Swift when the object comes into existence.
//    For the view controller that happens when it is loaded from the storyboard during app startup. At that point, its init?(coder) method is called.
//    That makes init?(coder) a great place for putting values into any variables that still need them
    
    required init?(coder aDecoder: NSCoder) {
        //// This instantiates the array. Now items contains a valid array object,
        // but the array has no ChecklistItem objects inside it yet.
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItems()
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        
    }
    
    //get the full path to the Documents folder
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    //construct the full path to the file that will store the checklist items
    func dataFilePath() -> URL {
       return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    func saveChecklistItems(){
        //take the contents of the items array and in two steps converts it to a block of binary data and then writes this data to a file
        let data = NSMutableData()
        //NSKeyedArchiver, which is a form of NSCoder that creates plist files, encodes the array and all the ChecklistItems in it into some sort of binary data format that can be written to a file.
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey:"ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems(){
        //put the results of dataFilePath() in a temporary constant named path
        let path = dataFilePath()
        //Try to load the contents of Checklists.plist into a new Data object -return nil if fails
        if let data = try? Data(contentsOf: path){
            //When the app does find a Checklists.plist file, you’ll load the entire array and its contents from the file.
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
    }
    
    
    
    //delegate methods
    //1
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    //2
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        //insert a new cell for it in the table view.
        tableView.insertRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
        
        dismiss(animated: true, completion: nil)
    }
    //3
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        //The row number is the same as the index of the ChecklistItem in the 'items' array
        if let index = items.index(of:item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        saveChecklistItems()
        dismiss(animated: true, completion: nil)
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
        //this returns a reference to the corresponding
        //UILabel object
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✔️"
        } else {
            label.text = ""
        }
    }

    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with:item)
        }
        saveChecklistItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //1. remove the item from the data model
        items.remove(at: indexPath.row)
        //2. delete the corresponding row from the table view.
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
        
    }


    //give data to the new view controller before it will be displayed
    //sender = control that triggered the segue, in this
    //case the table view cell whose disclosure button was tapped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            //This tells the ItemDetailViewController that from now on, the object known as self is its delegate
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = items[indexPath.row]
            }
            
        }
    }

}

