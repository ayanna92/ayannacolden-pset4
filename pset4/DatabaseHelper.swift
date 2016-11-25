//
//  DatabaseHelper.swift
//  pset4
//
//  Created by Ayanna Colden on 23/11/2016.
//  Copyright © 2016 Ayanna Colden. All rights reserved.
//

import Foundation
import SQLite 

class DatabaseHelper {
    
    private let users = Table("users")
    
    private let id = Expression<Int64>("id")
    private let todo = Expression<String?>("todo")
    
    private var db: Connection?
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            throw error
        }
    }
    
    private func createTable() throws {
        
        do {
            try db!.run(users.create(ifNotExists: true) {
                t in
                t.column(id, primaryKey: .autoincrement)
                t.column(todo)
            })
        } catch {
            throw error
        }
    }
    
    func create(todo: String) throws {
        
        let insert = users.insert(self.todo <- todo)
        
        do {
            let rowId = try db!.run(insert)
        } catch {
            throw error
            
        }
    }
    
    func read() throws -> [String]{
        var array = [String]()
        
        do {
            
            for user in try db!.prepare(users) {
                array.insert(user[todo]!, at: 0)
            }
        } catch {
            throw error
        }
        
        return array
    }
    
    func delete(task: String) throws {
        let deletedRows = users.filter(todo == task)
        
        do {
            try db!.run(deletedRows.delete())
        } catch {
            throw error
        }
    }
    
}
