//
//  ViewController.swift
//  pset4
//
//  Created by Ayanna Colden on 20/11/2016.
//  Copyright © 2016 Ayanna Colden. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let db = DatabaseHelper()
    @IBOutlet weak var todo: UITextField!
    var array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        
        do {
            array = try db!.read()
            self.tableView.reloadData()
            print(array)
        } catch {
            print(error)
        }
        
        if db == nil {
            print("Error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func create(_ sender: Any) {
        
        DispatchQueue.main.async{
            
            do {
                try self.db!.create(todo: self.todo.text!)
            } catch {
                print(error)
                
            }
            
            do {
                self.array = try self.db!.read()
                self.tableView.reloadData()
                print(self.array)
            } catch {
                print(error)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        
        cell.todoLabel.text = array[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            do {
                try db!.delete(task: array.remove(at: indexPath.row))
                print(array)
            } catch {
                print(error)
            }
            self.tableView.reloadData()
        }
    }
    
}






