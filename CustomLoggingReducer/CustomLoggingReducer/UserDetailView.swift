import ComposableArchitecture
import SwiftUI

@Reducer
struct UserDetail {
    @ObservableState
    struct State: Equatable {
        let user: User
    }
}

struct UserDetailView: View {
    let store: StoreOf<UserDetail>

    var body: some View {
        Text(store.user.name)
            .navigationTitle("User Detail")
    }
}
