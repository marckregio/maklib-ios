//
//  UserModel.swift
//  maklib
//
//  Created by Marck Regio on 17/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import Foundation


struct UserModel{
    
    static let NAME:String = "name"
    static let ADDRESS:String = "address"
    
    var name:String
    var address:String
    
    init(name:String, address:String) {
        self.name = name
        self.address = address
    }
    
    static func databaseColumns() -> [String]{
        var columns = [String]()
        columns.append(NAME)
        columns.append(ADDRESS)
        
        return columns
    }
    
    func databaseValues() -> [String]{
        var values = [String]()
        values.append(self.name)
        values.append(self.address)
        
        return values
    }
}
