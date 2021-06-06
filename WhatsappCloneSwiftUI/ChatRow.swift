import SwiftUI
import Firebase

struct ChatRow: View {
    var chatMessage: ChatModel
    var userToChat: UserModel
    var body: some View {
        Group{
            if chatMessage.messageFrom == Auth.auth().currentUser!.uid && chatMessage.messageTo == userToChat.uidFromFirebase {
                HStack {
                    Spacer()
                    Text(chatMessage.message)
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                }
                
            }
            else if chatMessage.messageFrom == userToChat.uidFromFirebase && chatMessage.messageTo == Auth.auth().currentUser!.uid {
                HStack{
                    Text(chatMessage.message)
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
            }
            else {
                
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95)
        
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chatMessage: ChatModel(id: 1, message: "message", uidFromFirebase: "uidFromFirebase", messageFrom: "messageFrom", messageTo: "messageTo", messageDate: Date(), messageFromMe: true), userToChat: UserModel(id: 1, name: "name", uidFromFirebase: "uidFromFirebase"))
    }
}
