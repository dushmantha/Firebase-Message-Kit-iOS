
import Foundation
import UIKit
import Firebase
import MessageKit
class UserRegisterViewController: UIViewController {
    @IBOutlet var userDisplayName: UITextField!
    
    @IBOutlet var btnUserCreate: UIButton!
    
    @IBAction func actionButtonPressed() {
        if userDisplayName.text == nil || (userDisplayName.text?.isEmpty)!{
            return
        }
        if let user = Auth.auth().currentUser {
            AppSettings.displayName = userDisplayName.text
            let sender = Sender(id: user.uid, displayName: AppSettings.displayName)
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChannelVC") as! ChannelListViewController
            vc.sender = sender
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }
    
    override func viewDidLoad() {
        btnUserCreate.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().signInAnonymously(completion: nil)
        userDisplayName.text = ""
    }
}
