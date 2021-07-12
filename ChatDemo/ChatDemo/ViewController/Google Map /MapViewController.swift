//
//  MapViewController.swift
//  ChatDemo
//
//  Created by Amit Chauhan on 28/04/20.
//  Copyright © 2020 Amit Chauhan. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

protocol LocationDelegate{
    func selectLocationwith(latitude : Double, longitude : Double, mapImageURL : String)
}

class MapViewController: UIViewController {

    @IBOutlet weak var map_View: GMSMapView!
    var locationCoordinate : CLLocationCoordinate2D!
    var locationDelegate : LocationDelegate!

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocation()

        map_View.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Action
    @IBAction func btn_backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send_locationAction(_ sender: Any) {
        /*
         https://maps.googleapis.com/maps/api/staticmap?center=28.9052,78.4673&zoom=13&size=600x300&maptype=roadmap
         &markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318
         &markers=color:red%7Clabel:C%7C40.718217,-73.998284
         &key=AIzaSyC6mxIWnQVEkBuOfrxlqE2SoqIM-n6SRSg
*/
        
        let lat = locationCoordinate.latitude
        let long = locationCoordinate.longitude
        let imageURL = "https://maps.googleapis.com/maps/api/staticmap?center=\(lat),\(long)&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=\(Constants.GOOGLE_API_KEY)"

        self.locationDelegate.selectLocationwith(latitude: lat, longitude: long, mapImageURL: imageURL)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    func getImageOnMap(){
        var semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "https://maps.googleapis.com/maps/api/staticmap?center=28.9052,78.4673&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyC6mxIWnQVEkBuOfrxlqE2SoqIM-n6SRSg")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8))
            let uiImage: UIImage = UIImage(data: data)!
            print("uiImage >> ",uiImage)

          semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func getImageonMap(){
        let lat = locationCoordinate.latitude
        let long = locationCoordinate.longitude
        let url = "https://maps.googleapis.com/maps/api/staticmap?center=\(lat),\(long)&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=\(Constants.GOOGLE_API_KEY)"

        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        
        Alamofire.request(escapedAddress!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: [:]).responseJSON { (response) in
            
            guard let data = response.data else{
                return
            }
            
            let uiImage: UIImage = UIImage(data: data)!
            print("uiImage >> ",uiImage)
//uiImage >>  <UIImage:0x600001365f80 anonymous {600, 300}>

        }
    }
    
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch let myJSONError {
            print("er >> ",myJSONError)
        }
        return nil
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func setPinOnMap(coordinate : CLLocationCoordinate2D){
        let lat = coordinate.latitude
        let long = coordinate.longitude

        map_View.clear()
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16.0)
        map_View.camera = camera
        map_View.isMyLocationEnabled = true

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = map_View
    }
}

extension MapViewController : LocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("didFailWithError")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("didUpdateLocations>> ", locations.last)
        
        guard let location = locations.first else {
          return
        }
        
        self.locationCoordinate = location.coordinate
        self.setPinOnMap(coordinate: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        debugPrint("didChangeAuthorization")
    }
    
    func startLocation(){
        LocationManager.sharedInstanse.startLocationManager()
        LocationManager.sharedInstanse.delegate = self
    }
}


extension MapViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
         let marker = GMSMarker(position: coordinate)
        debugPrint("didLongPressAtCoordinate>> ", coordinate)
        debugPrint("marker>> ", marker)
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        debugPrint("didTapAt>> ", coordinate)
        self.locationCoordinate = coordinate
        self.setPinOnMap(coordinate: coordinate)
    }
    
}


