//
//  QueryHelper.swift
//  maklib
//
//  Created by Marck Regio on 15/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import Foundation

class SQLQueryBuilder{
    
    static func CREATE(_ tableName: String,_ columns: [String]) -> String {
        var query: String = "CREATE TABLE if not exists \(tableName) (_id integer PRIMARY KEY autoincrement,"
        for col in columns{
            query.append(" \(col) text,")
        }
        query = String(query.dropLast(1))
        query.append(");")
        
        return query
    }
    
    static func INSERT(_ tableName: String, _ columns:[String], _ values: [String]) -> String {
        if columns.count == values.count {
            print("Values did not matched in count")
            return ""
        }
        var query: String = "INSERT INTO \(tableName) ("
        for col in columns{
            query.append(" \(col),")
        }
        query = String(query.dropLast(1))
        query.append(") VALUES (")
        for val in values{
            query.append("'\(val)',")
        }
        query = String(query.dropLast(1))
        query.append(");")
        
        return query
    }
    
    static func UPDATE(_ tableName: String, _ columns:[String], _ values: [String], whereClause: String) -> String {
        if columns.count == values.count {
            print("Values did not matched in count")
            return ""
        }
        var query: String = "UPDATE \(tableName) SET "
        for index in 0...columns.count {
            query.append("\(columns[index]) = '\(values[index])',")
        }
        query = String(query.dropLast(1))
        query.append("WHERE ")
        query.append("\(whereClause);")
        
        return query
    }
    
    static func SELECT(_ tableName:String, whereClause: String) -> String{
        var query: String
        if whereClause.isEmpty{
            query = "SELECT * FROM \(tableName);"
        } else {
            query = "SELECT * FROM \(tableName) Where \(whereClause);"
        }
        
        return query
    }
}
