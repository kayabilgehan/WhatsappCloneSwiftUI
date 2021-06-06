import SwiftUI
import Firebase

struct AuthView: View {
    
    let db = Firestore.firestore()
    
    @State var useremail = ""
    @State var password = ""
    @State var username = ""
    
    @State var showAuthView = true
    
    //@ObservedObject var userStore = UserStore()
    //Alttaki nesne kullanılırsa SceneDelegate içinde UserStore bind edilmeli
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        NavigationView {
            if showAuthView {
                //AUTH VIEW
                List {
                    Text("WhatApp Clone")
                        .font(.largeTitle)
                        .bold()
                    Section{
                        VStack(alignment: .leading) {
                            SectionSubTitle(subTitle: "User E-Mail")
                            TextField("User E-Mail", text: $useremail)
                        }
                    }
                    Section{
                        VStack(alignment: .leading) {
                            SectionSubTitle(subTitle: "User Password")
                            TextField("User Password", text: $password)
                        }
                    }
                    Section{
                        VStack(alignment: .leading) {
                            SectionSubTitle(subTitle: "User Username")
                            TextField("User Username", text: $username)
                        }
                    }
                    Section{
                        HStack{
                            Spacer()
                            Button(action: {
                                Auth.auth().signIn(withEmail: self.useremail, password: self.password) { result, error in
                                    if error != nil {
                                        print(error?.localizedDescription)
                                    } else {
                                        //User signed in
                                        self.showAuthView = false
                                    }
                                }
                            }){
                                Text("Sign In")
                            }.padding()
                            Spacer()
                        }
                    }
                    Section{
                        HStack{
                            Spacer()
                            Button(action: {
                                Auth.auth().createUser(withEmail: useremail, password: password) { result, error in
                                    if error != nil {
                                        print(error?.localizedDescription)
                                        //Alert(title: Text("Error!"), message: error?.localizedDescription, dismissButton: Alert.Button.cancel())
                                    }
                                    else {
                                        //User Screen e git
                                        var ref: DocumentReference? = nil
                                        let myUserDictionary: [String: Any] = ["username": self.username,
                                                                               "useremail": self.useremail,
                                                                               "userFirebaseId": result!.user.uid]
                                        ref = self.db.collection("users").addDocument(data: myUserDictionary, completion: { error in
                                            if error != nil {
                                                
                                            }
                                        })
                                        //Go to list
                                        self.showAuthView = false
                                    }
                                }
                            }){
                                Text("Sign Up")
                            }.padding()
                            Spacer()
                        }
                    }
                }
            }
            else {
                //USER VIEW
                NavigationView{
                    List(userStore.userArray) { user in
                        NavigationLink(
                            destination: ChatView(userToChat: user),
                            label: {
                                Text(user.name)
                            })
                    }
                }.navigationBarTitle(Text("Chat With Users"))
                .navigationBarItems(leading: Button(action: {
                    do {
                        try Auth.auth().signOut()
                    } catch {}
                    self.showAuthView = true
                }) {
                    Text("Log Out")
                })
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(showAuthView: false)
    }
}

struct SectionSubTitle: View {
    var subTitle: String
    var body: some View {
        return Text(subTitle)
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}
