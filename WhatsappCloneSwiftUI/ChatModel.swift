import Foundation
import SwiftUI

struct ChatModel: Identifiable {
    var id: Int
    var message: String
    var uidFromFirebase: String
    var messageFrom: String
    var messageTo: String
    var messageDate: Date
    var messageFromMe: Bool
}
