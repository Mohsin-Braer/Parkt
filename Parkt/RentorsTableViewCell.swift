//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import UIKit
import CoreLocation

class RentorsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainBackground: UIView!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var spotImageView: UIImageView!
    
   
    var currentLocation: CLLocation!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.spotImageView.image = UIImage(named: "P-2")
    }
    
    
    func configureCell(rentor: Rentors, photo: Photo){
        
        mainBackground.layer.cornerRadius = 10.0
        mainBackground.layer.masksToBounds = false
//        mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
//        mainBackground.layer.shadowOpacity = 1
//        mainBackground.layer.cornerRadius = 10
//        mainBackground.layer.shadowColor = UIColor(named: "Orange")?.cgColor
        
        spotImageView.clipsToBounds = true
        
        locationLabel.text = "\(rentor.city), \(rentor.state)" //configure this to city and state
        priceLabel.text = "$\(rentor.price)/Car"
        spotImageView.image = photo.image
        
        guard let currentLocation = currentLocation else {
            return
        }
        
        
        let distanceInMeters = currentLocation.distance(from: rentor.location) //convert from address to location
        let distanceString = "\((distanceInMeters*0.00062137).roundTo(places: 1)) miles"
        distanceLabel.text = distanceString
    }
   
}
