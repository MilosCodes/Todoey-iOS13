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


    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toDoCellId")


      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))

//      loadiItems()
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
    print(itemArray[indexPath.row])
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
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

  func saveItems() {

    do {
      try context.save()
    } catch {
      print("error saving \(error)")

    }
    tableView.reloadData()

  }

//  func loadiItems() {
//
//    if let data = try? Data(contentsOf: dataFilePath!) {
//      let decoder = PropertyListDecoder()
//      do {
//      itemArray = try decoder.decode([Item].self, from: data)
//      } catch {
//        print("error accured \(error)")
//      }
//    }
//  }
}

