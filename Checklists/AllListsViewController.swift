//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Polina Fiksson on 25/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    //an array that will hold the Checklist objects
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    //UIKit automatically calls this method after the view controller has become visible.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        if index != -1 {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(for:tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
    
        return cell
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        /*If the table view cannot find a cell to re-use (and it won’t until it has enough cells to fill the entire visible area), this method will return nil and you have to create your own cell by hand.*/
        
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            return cell
        }else{
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //save the chosen row to user defaults
        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        
        let checklist = dataModel.lists[indexPath.row]
        
       /* You can put anything you want into sender. If the segue is performed by the storyboard (rather than manually like you do here) then sender will refer to the control that triggered it, for example the UIBarButtonItem object for the Add button or the UITableViewCell for a row in the table. But because you start this particular segue by hand, you can put into sender whatever is most convenient.*/
        
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = IndexPath(row:newRowIndex, section:0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.index(of: checklist){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                cell.textLabel!.text = checklist.name
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //each view controller has a storyboard property that refers to the storyboard the view controller was loaded from
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        //was the back button tapped?
        if viewController === self {
            UserDefaults.standard.set(-1, forKey:"ChecklistIndex")
        }
    }
    
    //is called right before the segue happens. Here you get a chance to set the properties of the new view controller before it will become visible
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        }else if segue.identifier == "AddChecklist"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
    }
 


}
}
