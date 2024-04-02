import SwiftUI
import SharedModel

public struct HomeView: View {
    let user: User

    public init(user: User) {
        self.user = user
    }

    public var body: some View {
        VStack(spacing: 10) {
            Text("Hi, I'm \(user.name)!")
        }
        .padding()
    }
}

#Preview {
    HomeView(user: User(name: "alice"))
}
