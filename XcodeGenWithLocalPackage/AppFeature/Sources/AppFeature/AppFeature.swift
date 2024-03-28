import SwiftUI
import SharedModel
import HomeFeature
import LoginFeature
import ComposableArchitecture

@Reducer
public struct AppFeature {
    @ObservableState
    public struct State: Equatable {
        let user: User
        var isLoggedIn: Bool = false

        public init(
            user: User,
            isLoggedIn: Bool = false
        ) {
            self.user = user
            self.isLoggedIn = isLoggedIn
        }
    }

    public init() {}
}

public struct AppView: View {
    let store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }

    public var body: some View {
        if store.isLoggedIn {
            HomeView(user: store.user)
        } else {
            LoginView()
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppFeature.State(user: User(name: "alice"))
        ) {
            AppFeature()
        }
    )
}
