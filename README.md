## Welcome FirebaseMessageKit

You can use this project for integration firebase realtime message such as sample code for image and location share.


##### List down all methods which were implemented in the FirebaseMessageKit.

### App Delegate - Check firebase auth load chat composer for existing user
```markdown

    private func handleAppState() {
        if let user = Auth.auth().currentUser {
            let sender = Sender(id: user.uid, displayName: AppSettings.displayName)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard.init(name: "Chat", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ChannelVC") as! ChannelListViewController
             viewController.sender = sender
            let navigationController = UINavigationController.init(rootViewController: viewController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
    }
```

### UserRegister ViewController - work as a user register

```markdown
   func actionButtonPressed() {
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
```

### ChannelListViewController & Conversation ViewController & MapDetail ViewController - All of the method use for processing chat stuff.

