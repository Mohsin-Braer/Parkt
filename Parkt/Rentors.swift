//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.

import Foundation
import CoreLocation
import UIKit
import MapKit
import Firebase


class Rentors: NSObject {
    var name: String
    var documentID: String
    var userID: String
    var city: String
    var state: String
    var coordinates: CLLocationCoordinate2D
    var numSpots: Int
    var price: Int
    var email: String
    var phone: String
    
    var longitude: CLLocationDegrees {
        return coordinates.longitude
    }
    
    var latitude: CLLocationDegrees {
        return coordinates.latitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var dictionary: [String: Any]{
        return ["name": name, "userID": userID, "city": city, "state": state, "longitude": longitude, "latitude": latitude, "price": price, "numSpotsAvailable": numSpots, "email": email, "phone": phone]
    }
    
    init(name: String, documentID: String, userID: String, city: String, state: String, coordinates: CLLocationCoordinate2D, price: Int, numSpots: Int, email: String, phone: String){
        self.name = name
        self.documentID = documentID
        self.userID = userID
        self.city = city
        self.state = state
        self.coordinates = coordinates
        self.price = price
        self.numSpots = numSpots
        self.email = email
        self.phone = phone
    }
    
    convenience override init() {
        self.init(name: "", documentID: "", userID: "", city: "", state: "", coordinates: CLLocationCoordinate2D(), price: 0, numSpotAvailable: 0, email: "", phone: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let userID = dictionary["userID"] as! String? ?? ""
        let city =  dictionary["city"] as! String? ?? ""
        let state = dictionary["state"] as! String? ?? ""
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let price = dictionary["price"] as! Int? ?? 0
        let numSpotsAvailable = dictionary["numSpots"] as! Int? ?? 0
        let email = dictionary["email"] as! String? ?? ""
        let phone = dictionary["phone"] as! String? ?? ""
        self.init(name: name, documentID: "", userID: userID, city: city, state: state, coordinates: coordinates, price: price, numSpots: numSpots,  email: email, phone: phone)
    }
    
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        //Grab the userID
        guard let userID = (Auth.auth().currentUser?.uid) else {
            print("ERROR: Could not save data")
            return completed(false)
        }
        self.userID = userID
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("rentors").document(self.documentID)
            ref.setData(dataToSave){ (error) in
                if let error = error {
                    print("ERROR: updating document \(self.documentID)\(error.localizedDescription)")
                    completed(false)
                }else {
                    print("Document updated")
                    completed(true)
                }
            }
            
        }else {
            var ref: DocumentReference? = nil
            ref = db.collection("rentors").addDocument(data: dataToSave) {error in
                if let error = error {
                    print("ERROR: creating new document \(self.documentID)\(error.localizedDescription)")
                    completed(false)
                }else {
                    print("new document created ?? "unknown")")
                    self.documentID = ref?.documentID as! String
                    completed(true)
                }
            }
        }
    }
    
}
