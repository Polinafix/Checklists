//
//  DataModel.swift
//  Checklists
//
//  Created by Polina Fiksson on 22/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

/* DataModel will be taking over the responsibilities for loading and saving the to-do lists from AllListsViewController*/

import Foundation

class DataModel{
    var lists = [Checklist]()
    //as soon as the DataModel object is created, it will attempt to load Checklists.plist
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //convenience method-full path to the Documents folder
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    //construct the full path to the file that will store the checklists
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    //Here you tell the lists array that the Checklists it contains should be sorted usingsome formula. - closure is used
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) ==
                .orderedAscending })
    }
    
    // NSKeyedArchiver, which is a form of NSCoder that creates plist files, encodes the array and all the ChecklistItems in it into some sort of binary data format that can be written to a file.
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        // take the contents of the lists array and in two steps converts it to a
        //block of binary data and then writes this data to a file
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        //That data is placed in an NSMutableData object, which will write itself to the file specified by dataFilePath()
        data.write(to: dataFilePath(), atomically: true)
    }
    //UserDefaults will use the values from this dictionary if you ask it for a key but it cannot find anything under that key
    func registerDefaults() {
        let dictionary:[String:Any] = ["ChecklistIndex":-1, "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    //computed property
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    // this method is now called loadChecklists()
    func loadChecklists() {
        //put the results of dataFilePath() in a temporary constant named path
        let path = dataFilePath()
        //1.Try to load the contents of Checklists.plist into a new Data object
        //2.When the app does find a Checklists.plist file, you’ll load the entire array and its contents from the file.
        //3.You create an NSKeyedUnarchiver object (note: this is an unarchiver) and ask it to decode that data into the items array. This populates the array with exact copies of the ChecklistItem objects that were frozen into this file.
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            //
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
        }
        //make sure the existing lists are also sorted in the right order
        sortChecklists()
    }
}
