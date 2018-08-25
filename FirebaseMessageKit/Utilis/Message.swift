/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import CoreLocation
import Firebase
import MessageKit
import FirebaseFirestore

public struct MLocationItem: LocationItem {
    public var location: CLLocation
    public var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}

public struct MMediaItem: MediaItem {
    public var url: URL?
    public var image: UIImage?
    public var placeholderImage: UIImage
    public var size: CGSize
    
    init(image: UIImage?, url: URL?) {
        self.image = image
        self.url = url
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}

internal struct Message: MessageType {
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(image: UIImage,url: URL, sender: Sender, messageId: String, date: Date) {
        let mediaItem = MMediaItem(image: image, url : url)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(location: CLLocation, sender: Sender, messageId: String, date: Date) {
        let locationItem = MLocationItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, date: date)
    }
    
    
    
    // SHOW FIREBASE OBJECT
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Date else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        messageId = document.documentID
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)
        if let content = data["content"] as? String {
            self.kind = .text(content)
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            let mediaItem = MMediaItem(image: nil, url : url)
            self.kind = .photo(mediaItem)
            
        } else if let location = data["location"] as? String {
            let latLongString = location.components(separatedBy: "<+")[1].components(separatedBy: ">")[0]
            let lat = latLongString.components(separatedBy: ",")[0]
            let long = latLongString.components(separatedBy: ",")[1]
            
            if let latitude =  Double(lat), let longitude = Double(long) {
                let coordinate:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
                let locationItem = MLocationItem(location: coordinate)
                self.kind = .location(locationItem)
            } else {
                return nil
            }
        }else {
            return nil
        }
    }
}

// CREATE FIREBASE OBJECT
extension Message: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.id,
            "senderName": sender.displayName
        ]
        switch self.kind{
        case .location(let item) :
            let location : CLLocation = item.location
            let strLocation = String(describing: location)
            rep["location"] = strLocation
            break
        case .text(let item):
            rep["content"] = item
            break
        case .attributedText(_):
            break
        case .photo(let item):
            guard  let url : URL =  item.url else {
                break
            }
            rep["url"] = url.absoluteString
            break
        case .video(_):
            break
        case .emoji(_):
            break
        case .custom(_):
            break
        }
        
        
        
        return rep
    }
}

extension Message: Comparable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}

