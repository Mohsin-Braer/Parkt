//
//  Parkt
//
//  Created by Mohsin Braer on 11/18/21.
//

import UIKit

class ConfirmedController: UIViewController {
    
    var rentor: Rentors!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = rentors.name
        phoneLabel.text = rentors.phone
        emailLabel.text = rentors.email
        
    }
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
    }
}




