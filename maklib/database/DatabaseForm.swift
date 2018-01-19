//
//  DatabaseForm.swift
//  maklib
//
//  Created by Marck Regio on 18/01/2018.
//  Copyright © 2018 makunatApps. All rights reserved.
//

import UIKit

class DatabaseForm: UIViewController, UITableViewDataSource, UITableViewDelegate, OnRequestDelegate {
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var addressField: UITextField!
    
    @IBOutlet var dataView: UITableView!
    
    var userList = [UserModel]()
    let sql = SQLHelper()
    let userData = UserRequest()
    let alertHandler = AlertHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userData.onRequestDelegate = self
        userData.request()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = addressField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (name?.isEmpty)!{
            nameField.layer.borderColor = UIColor.red.cgColor
            return
        }
        if (address?.isEmpty)!{
            addressField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        let alert = alertHandler.showAlert(title: "Saving", message: "Are you sure?") { (result) in
            if result {
                let newUser = UserModel(id: String(arc4random()), name: name!, address: address!)
                self.sql.insertUser(user: newUser)
                
                self.nameField.text = ""
                self.addressField.text = ""
                
                self.reloadData()
            } else {
                self.nameField.text = ""
                self.addressField.text = ""
            }
        }
        self.present(alert, animated: true)
        
    }
    
    private func reloadData(){
        userList.removeAll()
        
        let result = sql.selectUsers(whereClause: "")
        for resultItem: UserModel in result{
            userList.append(UserModel(id: String(arc4random()), name: resultItem.name, address: resultItem.address))
        }
        
        print(userList.count)
        self.dataView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let user: UserModel = userList[indexPath.row]
        cell.textLabel?.text = user.name + "-" + user.address
        
        return cell
    }
    
    func onResult(_ result: String) {
        self.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
