import SwiftUI
import Firebase
import Combine

struct ChatView: View {
    let db = Firestore.firestore()
    
    var userToChat: UserModel
    @State var messageToSend = ""
    
    @ObservedObject var chatStore = ChatStore()
    
    var body: some View {
        VStack{
            
            /*List(chatStore.chatArray){chat in
                ChatRow(chatMessage: chat, userToChat: userToChat)
            }*/
            ScrollView{
                ForEach(chatStore.chatArray) { chat in
                    ChatRow(chatMessage: chat, userToChat: userToChat)
                }
            }
            
            HStack{
                TextField("Message", text: $messageToSend)
                    .padding()
                Button(action: sendMessageToFirebase) {
                    Text("Send")
                }.padding()
            }.padding()
        }
    }
    func sendMessageToFirebase(){
        var ref: DocumentReference? = nil
        
        let myChatDictionary : [String: Any] = ["chatUserFrom": Auth.auth().currentUser!.uid, "chatUserTo": userToChat.uidFromFirebase, "date": generateDate(), "message": self.messageToSend]
        
        ref = self.db.collection("chats").addDocument(data: myChatDictionary, completion: { error in
            if error != nil {
                
            }
            else {
                self.messageToSend = ""
            }
        })
    }
    
    func generateDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(userToChat: UserModel(id: 1, name: "Bilgehan", uidFromFirebase: "asdasdasd"))
    }
}
