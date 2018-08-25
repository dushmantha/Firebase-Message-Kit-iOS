
import Foundation
import FirebaseAuth
import FirebaseFirestore
import MessageKit

class ChannelListViewController: UITableViewController {
    
   
    private let db = Firestore.firestore()
    private let channelCellIdentifier = "channelCell"
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }
    
    private var channels = [Channel]()
    private var channelListener: ListenerRegistration?
    public var sender: Sender!
    deinit {
        channelListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: channelCellIdentifier)
        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else {
            return
        }
        switch change.type {
        case .added:
            addChannelToTable(channel)
        case .modified: break
        case .removed: break
            
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard !channels.contains(channel) else {
            return
        }
        channels.append(channel)
        channels.sort()
        guard let index = channels.index(of: channel) else {
            return
        }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func createChannel(channleName : String) {
        let channel = Channel(name: channleName)
        channelReference.addDocument(data: channel.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
    }
}
// MARK: - CREATE CHANNEL

extension ChannelListViewController {
    
     @IBAction func signOutBtnPressed(_ sender: Any) {
        let ac = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }))
        present(ac, animated: true, completion: nil)
        
       
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Channel Name", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Channel Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
             let chatChannel = alertController.textFields![0] as UITextField
            
            if !(chatChannel.text != nil && (chatChannel.text?.isEmpty)!){
                 self.createChannel(channleName: chatChannel.text!)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TableViewDelegate

extension ChannelListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: channelCellIdentifier, for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = channels[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let vc = ConversationViewController(sender: sender , channel: channel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


