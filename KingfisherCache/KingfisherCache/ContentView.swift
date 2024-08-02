import SwiftUI
import Kingfisher

struct ContentView: View {
    var body: some View {
        VStack {
            KFImage(URL(string: "https://placehold.jp/150x150.png")!)
                .resizable()
                .frame(width: 150, height: 150)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
