import Foundation
import SwiftUI
import Combine
import Firebase

//init kullanacaksan class yapıyorsun
class UserStore: ObservableObject {
    let db = Firestore.firestore()
    var userArray: [UserModel] = []
    //bir hata mesajı yollamaycasksan Never kullnılıyor
    var objectWillChange = PassthroughSubject<Array<Any>, Never>()
    
    init(){
        db.collection("users").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                self.userArray.removeAll(keepingCapacity: true)
                for document in snapshot!.documents {
                    if let userUidFromFirebase = document.get("userFirebaseId") as? String {
                        if let username = document.get("username") as? String {
                            let currentIndex = self.userArray.last?.id
                            let createdUser = UserModel(id: (currentIndex ?? -1) + 1, name: username, uidFromFirebase: userUidFromFirebase)
                            self.userArray.append(createdUser)
                        }
                    }
                }
                self.objectWillChange.send(self.userArray)
            }
        }
    }
}
