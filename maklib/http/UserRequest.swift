//
//  UserRequest.swift
//  maklib
//
//  Created by Marck Regio on 19/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import Foundation

class UserRequest: RESTHelper {
    
    var sql: SQLHelper
    
    init() {
        sql = SQLHelper()
        super.init(api: "api.json")
    }

    override func result(_ resultData: Data) {
        do {
            let results = try JSONDecoder().decode([UserModel].self, from: resultData)
            DispatchQueue.main.async {
                for item in results {
                    let findUser = self.sql.selectUsers(whereClause: "\(UserModel.ID) == '\(item.id)'")
                    if findUser.count == 0 {
                        self.sql.insertUser(user: item)
                    }
                }
                self.onRequestDelegate?.onResult(RESTHelper.RESULT_SUCCESS)
            }
        } catch let jsonError {
            DispatchQueue.main.async {
                self.onRequestDelegate?.onError(RESTHelper.RESULT_FAIL, description: jsonError.localizedDescription)
            }
        }
    }
    
}
