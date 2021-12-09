//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import UIKit
import GooglePlaces
import GoogleMaps

class NewParkingTableViewController: UITableViewController {
    
    @IBOutlet weak var locationSearchButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var carsLabel: UILabel!
    @IBOutlet weak var parkingSpotImageView: UIImageView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var rentors = Rentors()
    var imagePicker = UIImagePickerController()
    var photo = Photo()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        priceLabel.text = rentors.value
        carsLabel.text = rentors.cars
        
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func cameraOrLibraryAlert(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {_ in
            self.accessCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default){_ in
            self.accessLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }

    func enableDisableSaveButton() {
        if rentors.name == "" || rentors.phone == "" || rentors.email == "" || "\(locationSearchButton.titleLabel)" == "Lookup Location" {
              saveBarButton.isEnabled = false
          } else {
              saveBarButton.isEnabled = true
          }
      }
    
    func updateImage(picture: Photo){
        rentorImageView.image = picture.image
        photo = picture
    }

    @IBAction func nameTextFieldReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
        rentors.name = sender.text! ?? "unknown name"
        enableDisableSaveButton()
    }
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        cameraOrLibraryAlert()
    }
    
    @IBAction func lookupLocationPressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        enableDisableSaveButton()
    }
    
    @IBAction func emailTextField(_ sender: UITextField) {
         sender.resignFirstResponder()
        rentors.email = sender.text ?? "unknown email"
        enableDisableSaveButton()
    }
    @IBAction func phoneTextField(_ sender: UITextField) {
         sender.resignFirstResponder()
        rentors.phone = sender.text ?? "unknown phone"
        enableDisableSaveButton()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        rentors.name = nameTextField.text!
        
        rentors.saveData { success in
            if success {
                self.photo.saveData(rentor: self.rentors) { completed in
                    if completed {
                        self.performSegue(withIdentifier: "ViewRentors", sender: nil)
                    } else {
                        print("***ERROR: data wasn't saved")
                }
                }
            }else {
                print("***ERROR: data wasn't saved")
            }
        }
        
    }
    override func tableView(_ tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView?
    {
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        headerView.backgroundColor = UIColor.clear
      
      return headerView
    }
}
extension NewParkingTableViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let address = place.formattedAddress ?? "unknown location"
        rentors.coordinates = place.coordinate
        if(address != "unknown location"){
            locationSearchButton.setTitle("\(address)", for: .normal)
        }
        for addressComponent in (place.addressComponents)! {
            for type in (addressComponent.types){
                switch(type){
                case "locality":
                    rentors.city = addressComponent.name
                    
                case "administrative_area_level_1":
                    rentors.state = addressComponent.name
                    
                default:
                    break
                }
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
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


extension NewParkingTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let currentPhoto = Photo()
              currentPhoto.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true){
            self.updateImage(picture: currentPhoto)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func accessLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }else {
            showAlert(title: "Camera not available", message: "There is no camera available on this device.")
        }
    }
}




