//
//  UserModel.swift
//  maklib
//
//  Created by Marck Regio on 17/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import Foundation


struct UserModel: Codable{
    
    static let ID:String = "id"
    static let NAME:String = "name"
    static let ADDRESS:String = "address"
    
    var id:String
    var name:String
    var address:String
    
    //Auto init, use this if custom behavior needed
    /*init(name:String, address:String) {
        self.name = name
        self.address = address
    }*/
    
    static func databaseColumns() -> [String]{
        var columns = [String]()
        columns.append(ID)
        columns.append(NAME)
        columns.append(ADDRESS)
        
        return columns
    }
    
    static func columnIndex(columnName: String) -> Int {
        return databaseColumns().index(of: columnName)! + 1
    }
    
    func databaseValues() -> [String]{
        var values = [String]()
        values.append(self.id)
        values.append(self.name)
        values.append(self.address)
        
        return values
    }

}
