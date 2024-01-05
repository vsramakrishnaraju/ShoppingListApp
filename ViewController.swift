//
//  ViewController.swift
//  ShoppingList
//
//  Created by Venkata K on 1/4/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppinglist = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(refreshList))
        
        let right1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        let right2 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 10
        
        self.navigationItem.rightBarButtonItems = [right2, spacer, right1]
        
        refreshList()
    }
    
    @objc func refreshList() {
        title = "Shopping List"
        shoppinglist.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.capitalized
        
        if answer != "" {
            shoppinglist.insert(lowerAnswer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            showError(errorTitle: "Add Item", errorMessage: "Item cant be empty" )
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppinglist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppinglist[indexPath.row]
        return cell
    }
    
    @objc func shareTapped() {
        
        let list = shoppinglist.joined(separator: "\n")
        
        let name = "Shopping List"
        
        let vc = UIActivityViewController(activityItems: [list, name], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func showError(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

