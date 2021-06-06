import SwiftUI

struct TestView: View {
    @State var x = true
    var body: some View {
        NavigationView{
            if x {
                Text("X True")
            }
            else {
                Text("X False")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
