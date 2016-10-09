//
//  ThirdViewController.swift
//  ZH
//
//  Created by Rosa Rojas Domenech on 8/10/16.
//  Copyright © 2016 ZHTeam. All rights reserved.
//

import UIKit
import GoogleMaps

class ThirdViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    //ORIOL: mapView definition
    //var mapView = GMSMapView()
    
    //Variable that points to mapView in storyboard
    @IBOutlet weak var mapView: GMSMapView!
    
    //ORIOL: Add an instance of CLLocationManager
    let locationManager = CLLocationManager()
    
    //ORIOL: Timer declaration
    var timer = Timer()
    
    //ORIOL: marker's declaration
    var marker1 = GMSMarker()
    var marker2 = GMSMarker()
    var marker3 = GMSMarker()
    
    //ORIOL: This function tells the delegate that new location data is available
    func locationManager(_ manager:CLLocationManager,
                         didUpdateLocations locations:[CLLocation]) {
        
        //AQUI FEM ELS PUTS A LA BD AMB EL UPDATE DE COORDENADES
        
        let json = ["user": Gusername, "latitude": Double((locationManager.location?.coordinate.latitude)!), "longitude": Double((locationManager.location?.coordinate.longitude)!)] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        var request = URLRequest(url: URL(string: "http://10.192.118.193:8000/location/\(Gusername)")!)
        
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
        
        
        //This is used to follow the user location
        //mapView.animate(toLocation: (locationManager.location?.coordinate)!
        
        
    }
    var first = Bool(true)
    
    //ORIOL: This is the fire of the timer
    func fireTimer() {
        
        //AQUI VA ELS GET DE LA BD
        
        var distanceInMeters = Int()
        
        var request = URLRequest(url: URL(string: "http://10.192.118.193:8000/location/Carles")!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }

            let JSONDecoded = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = JSONDecoded as? [String: String] {
                let lat = Double(dictionary["latitude"]!)
                let long = Double(dictionary["longitude"]!)
                
                self.marker2.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)

                let coordinate0 = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                let coordinate1 = CLLocation(latitude: lat!, longitude: long!)
                
                distanceInMeters = Int(coordinate0.distance(from: coordinate1))
                
                if (distanceInMeters <= 3 && self.first){
                        self.first = false
                        let alert = UIAlertController(title: "ZOMBIE ALERT!!!", message: "There is a Z close by...", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.cancel))
                        self.present(alert, animated: true, completion: {
                            print("completion block")
                        })
                } else if (distanceInMeters > 3) { self.first = true }
                
            }
        }
        task.resume()
        
        //ORIOL: Update marker's location
        marker1.position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        //marker3.position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
    }

    
    //CARLES
    func UIColorFromHex(rgbValue:UInt32,alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //ORIOL: Permissions request
        //ORIOL: First we need to request permissions---------------------------------------
        locationManager.delegate = self
        
        //ORIOL: Request permission to use location services when using the app
        locationManager.requestWhenInUseAuthorization()
        
        //ORIOL: Request permission to use location services always
        locationManager.requestAlwaysAuthorization()
        
        //----------------------------------------------------------------------------
    
        //MARK: Map
        
        //ORIOL: Check if the user has location services enabled
        if CLLocationManager.locationServicesEnabled() {
            
            //ORIOL: Check the permissions status
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                
                //ORIOL: Ask the locationManager or updates on the user's location
                locationManager.startUpdatingLocation()
                
                //ORIOL: isMyLocationEnabled draws a light bluedot where user is located
                mapView.isMyLocationEnabled = false
                
                //ORIOL: myLocationButton adds a button to the map that, when tapped, centers the map on the user's location
                mapView.settings.myLocationButton = false
                
                //ORIOL: This is the first location of the camera
                 mapView.camera = GMSCameraPosition.camera(withTarget:(locationManager.location?.coordinate)!, zoom: 15)
                
                //CARLES: afegir estil
                do {
                    //Set the map style by passing the URL of the local file.
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                  NSLog("Unable to find style.json")
                }
                } catch {
                  NSLog("The style definition could not be loaded: \(error)")
                }
                
                //ORIOL: Timer
                timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ThirdViewController.fireTimer), userInfo: nil, repeats: true)
                
                marker1.position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                marker1.title = "Gisela Ruzafa"
                marker1.snippet = "Zombie"
                marker1.map = mapView
                marker1.icon = GMSMarker.markerImage(with: UIColor.green)
                
                marker2.title = "Carles Rojas"
                marker2.snippet = "Human"
                marker2.map = mapView
                marker2.icon = GMSMarker.markerImage(with: UIColor.orange)
                
            }
        } else {
            print("Location services are not enabled")
        }
        
        // Do any additional setup after loading the view.
    }
}
