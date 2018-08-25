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

import MessageKit
import CoreLocation

final internal class SampleData {

    static let shared = SampleData()

    private init() {}



    let dan = Sender(id: "123456", displayName: "Dan Leonard")
    let steven = Sender(id: "654321", displayName: "Steven")
    let jobs = Sender(id: "000001", displayName: "Steve Jobs")
    let cook = Sender(id: "656361", displayName: "Tim Cook")

    

    func getAvatarFor(sender: Sender) -> Avatar {
        switch sender {
        case dan:
            return Avatar(image: #imageLiteral(resourceName: "Dan-Leonard"), initials: "DL")
        case steven:
            return Avatar(initials: "S")
        case jobs:
            return Avatar(image: #imageLiteral(resourceName: "Steve-Jobs"), initials: "SJ")
        case cook:
            return Avatar(image: #imageLiteral(resourceName: "Tim-Cook"))
        default:
            return Avatar()
        }
    }

}
