//
//  Parkt
//
//  Created by Mohsin Braer on 11/17/21.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var summary: String
    var publisher: String
    var date: Date
    var documentUUID: String
    
    var dictionary: [String: Any] {
        return ["summary": summary, "publisher": publisher, "date": date]
    }
    
    init(image: UIImage, summary: String, publisher: String, date: Date, documentUUID: String) {
        self.image = image
        self.summary = summary
        self.publisher = publisher
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        let publisher = Auth.auth().currentUser?.email ?? "Unable to identify user"
        self.init(image: UIImage(), summary: "", publisher: publisher, date: Date(), documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let summary = dictionary["summary"] as! String? ?? ""
        let publisher = dictionary["publisher"] as! String? ?? ""
        let timestamp = dictionary["date"] as! Timestamp? ?? Timestamp()
        let date = timestamp.dateValue()
        self.init(image: UIImage(), summary: summary, publisher: publisher, date: date, documentUUID: "")
    }
    
    func saveData(rentors: Rentors, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("*** ERROR: could not convert image")
            return completed(false)
        }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        documentUUID = UUID().uuidString // generate a unique ID to use for the photo image's name
        // create a ref to upload storage to spot.documentID's folder (bucket), with the name we created.
        let storageRef = storage.reference().child(rentors.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetadata) {metadata, error in
            guard error == nil else {
                print("ERROR during .putData storage upload for reference \(storageRef). Error: \(error!.localizedDescription)")
                return
            }
            print("Upload Successful. Metadata is \(metadata!)")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            let ref = db.collection("rentors").document(rentors.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentUUID) \(rentors.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("*** ERROR: upload task for file \(self.documentUUID) failed, in rentors \(rentors.documentID), error \(error)")
            }
            return completed(false)
        }
    }
}
