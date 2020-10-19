//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  var itemArray = [Item]()
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toDoCellId")


      let newItem = Item()
      newItem.title = "Find Mike"
      itemArray.append(newItem)

      let newItem1 = Item()
      newItem1.title = "Ello"
      itemArray.append(newItem1)

      let newItem2 = Item()
      newItem2.title = "Buy Eggs"
      itemArray.append(newItem2)


      loadiItems()
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

      let newItem = Item()
      newItem.title = textField.text!
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

    let encoder = PropertyListEncoder()

    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print("error encoding item array, \(error)")
    }
    tableView.reloadData()

  }

  func loadiItems() {
    
    if let data = try? Data(contentsOf: dataFilePath!) {
      let decoder = PropertyListDecoder()
      do {
      itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print("error accured \(error)")
      }
    }
  }
}

