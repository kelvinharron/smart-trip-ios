import UIKit
import GoogleSignIn
import Firebase
class WelcomeViewController: UIViewController, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var googleSignIn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
         googleSignIn.style = .iconOnly
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
//        showSpinner {
            if let user = Auth.auth().currentUser {
                user.link(with: credential) { (user, error) in
//                    self.hideSpinner {
                        if let error = error {
                            debugPrint(error.localizedDescription)
//                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        
//                    }
                }
            } else {
                Auth.auth().signIn(with: credential) { (user, error) in
//                    self.hideSpinner {
                        if let error = error {
                            debugPrint(error.localizedDescription)
//                            self.showMessagePrompt(error.localizedDescription)
                            
                            return
                        }
                        // User is signed in
//                    }
                }
            }
//        }
    }
    
}
