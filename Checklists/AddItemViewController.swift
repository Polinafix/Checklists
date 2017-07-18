//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Polina Fiksson on 12/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation
import UIKit

//AddItemViewControllerDelegate protocol
protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController,
                               didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    //property that the VC can use to refer to the delegate
    weak var delegate: AddItemViewControllerDelegate?
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //“Is there a delegate? Then send the message"
        delegate?.addItemViewControllerDidCancel(self)
        
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
       // create a new ChecklistItem object with the text from the text field
        let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
        
        delegate?.addItemViewController(self, didFinishAdding: item)
      
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
