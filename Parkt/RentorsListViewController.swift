//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI

class RentorsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var rentors = Rentors()
    var currentLocation: CLLocation!
    var photos = Photos()
    var searchRadius: Int!
    var pictures: [String: Photo] = [:]
    typealias didLoad = () -> ()
    
    func loadPhoto(rentor: Rentors, completed: @escaping didLoad) {
        self.photos.loadData(rentors: rentor) { () -> () in
            self.pictures[rentors.documentID] = self.photos.photo
            completed()
        }
    }
    
    func loadPictures(completed: @escaping didLoad) {
        rentors.loadLocationArray(searchRadius: searchRadius, currentLocation: currentLocation) {}
        for rentor in self.rentors.locationRentorsArray {
            loadPhoto(rentors: rentor) { () -> () in
                self.tableView.reloadData()
            }
            completed()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPictures {}
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! RentorsDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            let rentor = rentors.locationRentorsArray[selectedIndexPath.row]
            destination.rentors = rentor
            destination.photo = self.pictures[rentor.documentID]
            
        } else {
            print("***ERROR: Couldn't select row")
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
            
        }
    }
}

extension RentorsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentors.locationRentorsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rentors = rentors.locationRentorsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RentorsTableViewCell
        cell.locationLabel.text = "\(rentors.city), \(rentors.state)"
        if let currentLocation = currentLocation {
            cell.currentLocation = currentLocation
        }
        cell.distanceLabel.text = ""
        
        let blank = Photo()
        blank.image = UIImage(named: "squirrel") ?? UIImage()
        let image = pictures[rentors.documentID] ?? blank
        
        cell.configureCell(rentor: rentors.locationRentorsArray[indexPath.row], photo: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    
    
}

