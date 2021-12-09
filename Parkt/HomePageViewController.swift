//
//  Parkt
//
//  Created by Mohsin Braer on 11/10/21.
//

import UIKit
import Firebase
import FirebaseAuthUI
import GoogleSignIn

class HomePageViewController: UIViewController {

    var authUI: FUIAuth!
    var rentors = Rentors()
    
    @IBOutlet weak var houseButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
        setupUserInterface()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        signIn()
    }
    
    func setupUserInterface(){
        houseButton.layer.cornerRadius = 20.0
        carButton.layer.cornerRadius = 20.0
        
    }
    
    func loadSelfArray() {
        rentors.loadYourArray {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewRentors" {
            let destination = segue.destination as! ViewRentorsViewController
            loadSelfArray()
            destination.rentors = self.rentors
        }
    }
    
    func signIn() {
             let providers: [FUIAuthProvider] = [
                 FUIGoogleAuth(),]
             let currentUser = authUI.auth?.currentUser
             if authUI.auth?.currentUser == nil {
                 self.authUI?.providers = providers
                 let loginViewController = authUI.authViewController()
                 loginViewController.modalPresentationStyle = .fullScreen
                 present(loginViewController, animated: true, completion: nil)
             } else {
                // tableView.isHidden = false
             }
         }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            
            signIn()
        }catch {
            print("***ERROR: Couldn't sign out")
           
        }
    }

}

extension HomePageViewController: FUIAuthDelegate{
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            print("***We signed in with the user \(user.email ?? "unknown email")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        //create instance of FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        //set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        //create frame for an ImageView to hold our logo
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "P")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
        
    }
}
