import SwiftUI
import ComposableArchitecture

@main
struct CustomLoggingReducerApp: App {
    var body: some Scene {
        WindowGroup {
            UserListView(
                store: Store(initialState: UserList.State(users: User.users)) {
                    UserList()
                }
            )
        }
    }
}
