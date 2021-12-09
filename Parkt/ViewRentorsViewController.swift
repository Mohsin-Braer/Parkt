//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI

class ViewRentorsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var rentors = Rentors()
    var photos = Photos()
    var pictures: [String: Photo] = [:]
    typealias didLoad = () -> ()
    
    func loadRentorsPhoto(rentor: Rentors, completed: @escaping didLoad) {
        self.photos.loadData(rentor: rentor) { () -> () in
            self.pictures[rentors.documentID] = self.photos.photo
            completed()
        }
    }
    
    func loadPicture(completed: @escaping didLoad) {
        for rentor in self.rentors.rentorsArray {
            loadRentorsPhoto(rentor: rentor) { () -> () in
                self.tableView.reloadData()
            }
        }
        completed()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        rentors.loadYourArray {
            self.loadPicture {}
        }
            
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
    }
    
    
}
extension ViewRentorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentors.rentorsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RentorCell", for: indexPath) as! ViewRentorsTableViewCell
        let rentor = rentors.rentorsArray[indexPath.row]
        cell.numSpotsLabel.text = "\(rentor.numSpots) Spots Left"
        cell.locationLabel.text = "\(rentor.city), \(rentor.state)"
        cell.priceLabel.text = "$\(rentor.price)/Car"
       
        
        let blank = UIImage(named: "tree") ?? UIImage()
        cell.rentorImageView.image = pictionary[rentors.documentID]?.image ?? blank
        
        return cell
    }
    
    //called whenever your table needs to know the height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}


