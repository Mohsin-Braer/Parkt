//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import UIKit

class RentorsDetailViewController: UIViewController {
    
    var rentors: Rentors!
    var photo: Photo!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberSpotsLeftLabel: UILabel!
    @IBOutlet weak var numberSpotsLabel: UILabel!
    @IBOutlet weak var numberDaysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if rentors == nil {
            rentors = Rentors()
        }
        if photo == nil {
            photo = Photo()
        }
        
        self.updateInterface()
    }
    
    func updateInterface(){
        nameLabel.text = rentors.name
        numberSpotsLabel.text = "3"
        numberDaysLabel.text = "14"
        locationLabel.text = "\(rentors.city), \(rentors.state)"
        numberSpotsLeftLabel.text = "\(rentors.numSpots) Cars Left"
        totalPriceLabel.text = "Total: $\(rentors.price * 10 * 10)"
        priceLabel.text = "$\(rentors.price)/car per day"
        spotImageView.image =  photo.image
    }
    
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
              let destination = segue.destination as! ConfirmedController
              destination.rentors = rentors
             
              }
    
    
    func calcTotalPrice(){
        let totalPrice = rentors.price
        totalPriceLabel.text = "Total: $\(totalPrice)"
    }
}



