//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Elle on 2018/8/28.
//  Copyright © 2018 skyblue. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryItem = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
       
    }
    

    // MARK: - Table view data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryItem[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }

    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryItem[indexPath.row]
            
        }
        
        
    }

   
    // MARK: - Data Manipulation Methods
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryItem = try context.fetch(request)
        } catch {
            print("Error with fetching category : \(error)")
        }
        
    }
    
    
    // MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            //what will happen once the user click the Add Category button on our UIAlert
            let newCategory = Category(context: self.context)
            print(newCategory)
            newCategory.name = textField.text!
            
            self.categoryItem.append(newCategory)
            self.saveCategory()
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error with saving context: \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    

    
}
