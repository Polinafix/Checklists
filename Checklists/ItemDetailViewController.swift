//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Polina Fiksson on 12/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation
import UIKit

//ItemDetailViewControllerDelegate protocol
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    var itemToEdit:ChecklistItem?
    let controller:ChecklistViewController? = nil
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    //property that the VC can use to refer to the delegate
    weak var delegate: ItemDetailViewControllerDelegate?
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    var dueDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.delegate = controller
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.delegate = controller
        textField.becomeFirstResponder()
    }
    //To convert the Date value to text, you use the DateFormatter object
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    
    
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //“Is there a delegate? Then send the message"
        delegate?.itemDetailViewControllerDidCancel(self)
        
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        if let item  = itemToEdit{
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }else{
            // create a new ChecklistItem object with the text from the text field
        let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
            
        item.shouldRemind = shouldRemindSwitch.isOn
        item.dueDate = dueDate
        
        delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
       
    }
    //disable selecting the row
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    
}
