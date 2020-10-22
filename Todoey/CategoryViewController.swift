//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Milos Milivojevic on 10/22/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

  var categories = [`Category`]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
    loadCategories()

  }

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

    var textField = UITextField()
    let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in

      let newCategory = Category(context: self.context)
      newCategory.name = textField.text!
      self.categories.append(newCategory)
      self.saveCategories()
    }
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Add new category"
      textField = alertTextField
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }



  //MARK: -TableViewDelegate Methods


}


//MARK: -TableViewDataSource Methods

extension CategoryViewController {


  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categories[indexPath.row].name

    return cell
  }

  

}

extension CategoryViewController: NSFetchRequestResult {


  //MARK: -Data manipulation Methods


  func saveCategories() {

    do {
      try context.save()
    } catch {
      print("error saving \(error)")

    }
    tableView.reloadData()

  }

  func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

    //    let request: NSFetchRequest<Item> = Item.fetchRequest()
    do {
      categories = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }

    tableView.reloadData()
  }

}
