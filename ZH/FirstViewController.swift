//
//  FirstViewController.swift
//  ZH
//
//  Created by Rosa Rojas Domenech on 8/10/16.
//  Copyright © 2016 ZHTeam. All rights reserved.
//
import UIKit

class FirstViewController: UIViewController {
    
    func UIColorFromHex(rgbValue:UInt32,alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    @IBOutlet weak var Silueta: UIImageView!
    @IBOutlet weak var Tipus: UILabel!
    @IBOutlet weak var nom: UILabel!
    
    var zombie = BooleanLiteralType(true)
    var human = BooleanLiteralType(false)
    var savior = BooleanLiteralType(false)
    var infected = BooleanLiteralType(false)
    var name = String("Gisela Ruzafa")
    var sex = String("woman")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nom.text = name
        
        if zombie{
            
            Tipus.text = "ZOMBIE"
            self.view.backgroundColor = UIColorFromHex(rgbValue: 0x14970E, alpha: 1)
            if sex == "man"{
                Silueta.image = UIImage(named:"Silhouettes-2")
            }
            else if sex == "woman"{
                Silueta.image = UIImage(named:"Silhouettes-5")
            }
        }
            
        else if human{
            Tipus.text = "HUMAN"
            self.view.backgroundColor = UIColorFromHex(rgbValue: 0xD88B05, alpha: 1)
            if sex == "man"{
                Silueta.image = UIImage(named:"Silhouettes-10")
            }
            else if sex == "woman"{
                Silueta.image = UIImage(named:"Silhouettes-8")
            }
        }
            
        else if savior{
            Tipus.text = "SAVIOR"
            self.view.backgroundColor = UIColorFromHex(rgbValue: 0x35A6D8, alpha: 1)
            Silueta.image = UIImage(named:"poti")
        }
        else if infected{
            Tipus.text = "INFECTED"
            self.view.backgroundColor = UIColorFromHex(rgbValue: 0x970300, alpha: 1)
            if sex == "man"{
                Silueta.image = UIImage(named:"Silhouettes-10")
            }
            else if sex == "woman"{
                Silueta.image = UIImage(named:"Silhouettes-8")
            }
            
        }
        
    }

  


}

