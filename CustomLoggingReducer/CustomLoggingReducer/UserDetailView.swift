import ComposableArchitecture
import SwiftUI

@Reducer
struct UserDetail {
    @ObservableState
    struct State: Equatable, OpenLoggableState {
        let user: User
        var message: String { "Hello, \(user.name) "}
    }

    enum Action: OpenLoggableAction {
        case open(OpenAction)
    }

    var body: some ReducerOf<Self> {
        OpenLoggingReducer()
    }
}

struct UserDetailView: View {
    let store: StoreOf<UserDetail>

    var body: some View {
        Text(store.user.name)
            .onAppear {
                store.send(.open(.onAppear))
            }
            .navigationTitle("User Detail")
    }
}
