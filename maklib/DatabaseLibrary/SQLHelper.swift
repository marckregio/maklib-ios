//
//  SQLHelper.swift
//  maklib
//
//  Created by Marck Regio on 15/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import Foundation
import SQLite3

class SQLHelper{
    
    let DATABASENAME: String = "maklib.sqlite"
    let USER: String = "user"
    var sqlLocation: URL
    var db: OpaquePointer?
    
    init() {
        sqlLocation = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        self.sqlLocation.appendPathComponent(DATABASENAME)
    }
    
    private func openDatabase(){
        if sqlite3_open(sqlLocation.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    
    private func closeDatabase(){
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
    
    func createDatabase(){
        openDatabase()
        if sqlite3_exec(db, SQLQueryBuilder.CREATE(USER, UserModel.databaseColumns()), nil, nil, nil) != SQLITE_OK {
            let err = String(describing: sqlite3_errmsg(db)!)
            print(err)
        } else {
            print(SQLQueryBuilder.CREATE(USER, UserModel.databaseColumns()))
        }
        closeDatabase()
    }
    
    func insert(user:UserModel){
        openDatabase()
        if sqlite3_exec(db, SQLQueryBuilder.INSERT(USER, UserModel.databaseColumns(), user.databaseValues()), nil, nil, nil) != SQLITE_OK {
            let err = String(describing: sqlite3_errmsg(db)!)
            print(err)
        } else {
            print(SQLQueryBuilder.INSERT(USER, UserModel.databaseColumns(), user.databaseValues()))
        }
        closeDatabase()
    }
    
    func select(user:UserModel, whereClause:String) -> [String: String]{
        openDatabase()
        var pointer: OpaquePointer?
        var returnMap = [String: String]()
        if sqlite3_prepare(db, SQLQueryBuilder.SELECT(USER, whereClause: whereClause) , -1, &pointer, nil) != SQLITE_OK {
            let err = String(describing: sqlite3_errmsg(db)!)
            print(err)
        }
        
        var index = 0
        while(sqlite3_step(pointer) == SQLITE_ROW){
            returnMap[UserModel.databaseColumns()[index]] = String(describing: sqlite3_column_text(pointer, Int32(index)))
            index += 1
        }
        
        closeDatabase()
        return returnMap
    }
}

