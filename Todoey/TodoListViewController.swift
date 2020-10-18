//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  var itemArray = ["Banana",
                   "Apple",
                   "Carrot",
                   "Your Mom"
  ]

  let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toDoCellId")

      if let items = defaults.array(forKey: "TodoListArray") as? [String] {
        itemArray = items
      }
    }
  //MARK: -tableView Data Source methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCellId", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }

  //MARK: -tableViewDelegate methods

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(itemArray[indexPath.row])

    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    tableView.deselectRow(at: indexPath, animated: true)

  }
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add item", style: .default) { (action) in
      // what will happen once the user clicks the add item button on our UIAlert
      self.itemArray.append(textField.text ?? "Unknow Item")

      self.defaults.set(self.itemArray, forKey: "TodoListArray")

      self.tableView.reloadData()
    }
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Writte something"
      textField = alertTextField
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}

