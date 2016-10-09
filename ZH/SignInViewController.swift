//
//  SignInViewController.swift
//  ZH
//
//  Created by Rosa Rojas Domenech on 8/10/16.
//  Copyright © 2016 ZHTeam. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: register/sign in
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    var sex = String()
    var url = "http://10.192.118.193:8000/users/"
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "SignInSegoe" {
                return false
            }
        }
        return true
    }
    
    @IBAction func ManButtonPressed(_ sender: UIButton) {
        sex = "man"
    }
    
    @IBAction func WomanButtonPressed(_ sender: UIButton) {
        sex = "woman"
    }
    
    // MARK: teclat
    @IBAction func signInPressed(_ sender: UIButton) {
        self.name.resignFirstResponder()
        self.password.resignFirstResponder()
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        self.name.resignFirstResponder()
        self.password.resignFirstResponder()
        
        Gusername = self.name.text!
        Gpassword = self.password.text!
        
        
    }
    //MARK:Pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func SignIn(_ sender: UIButton) {
        print("button tapped")
        let json = ["username":String(describing: self.name.text!), "password":String(describing: self.password.text!), "sex":sex]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
                self.name.text = "Error"
                self.password.text = "Error"
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
        self.name.text = ""
        self.password.text = ""
        
    }
    
   
    @IBAction func LogIn(_ sender: UIButton) {
        print("button tapped")
        let usuari = self.name.text!
        var request = URLRequest(url: URL(string: "http://10.192.118.193:8000/users/\(usuari)")!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.name.text = "Error"
                self.password.text = "Error"
                return
            }
            guard let data = data else {
                self.name.text = "The user dosen't exists"
                self.password.text = "The user dosen't exists"
                return
            }
            
            let JSONDecoded = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = JSONDecoded as? [String: String] {
                let DB_user = dictionary["username"]
                let DB_password = dictionary["password"]
                
                if (DB_user! != self.name.text || DB_password! != self.password.text){
                    //Anar a següent pantalla
                    self.name.text = "Error"
                    self.password.text = "Error"
                }
                else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "LogInSegoe", sender: nil)
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    @IBAction func manB(_ sender: UIButton) {
         print("button tapped")
    }
   

    @IBAction func womanB(_ sender: UIButton) {
         print("button tapped")
    }
}
