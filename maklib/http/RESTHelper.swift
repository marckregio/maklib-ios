//
//  RESTHelper.swift
//  maklib
//
//  Created by Marck Regio on 19/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import Foundation

protocol OnRequestDelegate: class {
    func onResult(_ result: String)
    func onError(_ result: String, description: String)
}

class RESTHelper{
    
    static let RESULT_SUCCESS = "Success"
    static let RESULT_FAIL = "Failed";
    
    let BASE_API: String = "http://localhost:4000/files/"
    var API_String: String = ""
    var onRequestDelegate: OnRequestDelegate?
    
    init(api:String){
        self.API_String = BASE_API + api
    }
    
    func request(){
        guard let API_URL = URL(string: API_String) else {return}
        URLSession.shared.dataTask(with: API_URL) {
            (data, response, error) in
            if error != nil {
                self.onError(error!.localizedDescription)
            }
            
            guard let data = data else {return}
            self.result(data)
            
        }.resume()
    }
    
    func result(_ resultData: Data){
        //override in child class
    }
    
    func onError(_ errorMessage: String){
        DispatchQueue.main.async {
            self.onRequestDelegate?.onError(RESTHelper.RESULT_FAIL, description: errorMessage)
        }
    }
}
