//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
  
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var itemArray = [Item]()
  
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toDoCellId")
    
  }
  //MARK: -tableView Data Source methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCellId", for: indexPath)
    let item = itemArray[indexPath.row]
    
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    
    
    
    return cell
  }
  
  //MARK: -tableViewDelegate methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    //    itemArray[indexPath.row].setValue("Completed", forKey: "title")
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    //    context.delete(itemArray[indexPath.row])
    //    itemArray.remove(at: indexPath.row)
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    saveItems()
    
  }
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add item", style: .default) { [self] (action) in
      // what will happen once the user clicks the add item button on our UIAlert
      
      let newItem = Item(context: self.context)
      newItem.title = textField.text!
      newItem.done = false
      newItem.parentCategory = self.selectedCategory
      self.itemArray.append(newItem)
      
      saveItems()
    }
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Writte something"
      textField = alertTextField
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  //MARK: - Model Manipulation
  
  func saveItems() {
    
    do {
      try context.save()
    } catch {
      print("error saving \(error)")
      
    }
    tableView.reloadData()
    
  }
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory?.name! as! CVarArg)

    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    } else {
      request.predicate = categoryPredicate
    }

    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
    
    tableView.reloadData()
  }
  
}
//MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
  
  
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    //MARK: -REQUEST (for sorting *and* arrays)
    request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadItems(with: request)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
      
    }
  }
}
