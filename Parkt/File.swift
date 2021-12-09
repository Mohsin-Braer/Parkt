//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import Foundation
import Firebase
import GeoFire

class Rentors {
    var rentorsArray = [Rentors]()
    var locationRentorsArray = [Rentors]()
    var rentorsArray = [Rentors]()
    
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
        
    }
    
    func loadData(completed: @escaping ()->()){
        db.collection("rentors").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("***ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.rentorsArray = []
            //there are questSnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let rentor = Rentors(dictionary: document.data())
                rentor.documentID = document.documentID
                self.rentorArray.append(rentor)
            }
            completed()
        }
    }
    
    func loadLocationArray(searchRadius: Int, currentLocation: CLLocation, completed: @escaping ()->()){
        
        db.collection("rentor").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("***ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.locationRentorsArray = []
            //there are questSnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let rentor = Rentors(dictionary: document.data())
                let distanceInMeters = currentLocation.distance(from: rentor.location)
                let distanceInMiles = (distanceInMeters*0.00062137).roundTo(places: 1)
                if(distanceInMiles <= Double(searchRadius)){
                    rentor.documentID = document.documentID
                    self.locationRentorsArray.append(rentor)
                    
                }
            }
            completed()
        }
    }
    
    func loadYourArray(completed: @escaping ()->()){
        
        db.collection("rentor").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("***ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.rentorsArray = []
            //there are questSnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let rentor = Rentors(dictionary: document.data())
                guard let userID = (Auth.auth().currentUser?.uid) else {
                    print("ERROR: Could not save data")
                    return completed()
                }
                if(rentor.userID == userID){
                    rentor.documentID = document.documentID
                    self.rentorsArray.append(rentor)
                }
            }
            completed()
        }
    }
    
}

