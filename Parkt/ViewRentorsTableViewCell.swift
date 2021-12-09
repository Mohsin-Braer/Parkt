//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import UIKit

class ViewRentorsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rentorImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numSpotsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.rentorImageView.image = UIImage(named: "squirrel")
    }
    
    func setupInterface(){
        mainBackground.layer.cornerRadius = 10.0
        mainBackground.layer.masksToBounds = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInterface()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
