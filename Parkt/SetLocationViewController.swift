//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

class SetLocationViewController: UIViewController {
    
    var coordinate = CLLocationCoordinate2D()
    var city = ""
    var state = ""
    var searchRadius = 5
    var currentLocation = CLLocation()
    var rentors = Rentors()
    var photos = Photos()
    var pictionary: [String: Photo]! = [:]
    
    
    @IBOutlet weak var lookupLocationLabel: UIButton!
    @IBOutlet weak var searchRadiusLabel: UILabel!
    @IBOutlet weak var searchRadiusSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchRadius = Int(searchRadiusSlider.value)
        
    }
    
    
    func loadLocArray() {
        rentors.loadLocationArray(searchRadius: searchRadius, currentLocation: currentLocation) {
        }
    }

    
    @IBAction func lookupLocationButtonPressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        
        
    }
    @IBAction func searchRadiusSliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        
        searchRadiusLabel.text = "\(Int(sender.value)) \(Int(sender.value) == 1 ? "mile": "miles")"
        searchRadius = Int(sender.value)
        
        loadLocArray()
    }
    
    @IBAction func nextBarButtonPressed(_ sender: UIBarButtonItem) {
        loadLocArray()
        performSegue(withIdentifier: "ShowRentors", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRentors" {
            let destination = segue.destination as! RentorsListViewController
            destination.searchRadius = searchRadius
            destination.currentLocation = currentLocation
            loadLocArray()
            destination.rentors = rentors
        }
    }
}
extension SetLocationViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        coordinate = place.coordinate
        currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        for addressComponent in (place.addressComponents)! {
            for type in (addressComponent.types){
                switch(type){
                case "locality":
                    city = addressComponent.name
                    
                case "administrative_area_level_1":
                    state = addressComponent.name
                    
                default:
                    break
                }
                
            }
        }
        if(city != "" && state != ""){
            lookupLocationLabel.setTitle("\(city), \(state)", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
