import SwiftUI
import ComposableArchitecture

@Reducer
struct UserList {
    @ObservableState
    struct State {
        var users: IdentifiedArrayOf<User>
        @Presents var destination: Destination.State?

        init(users: IdentifiedArrayOf<User>) {
            self.users = users
        }
    }

    @Reducer(state: .equatable)
    enum Destination {
        case userDetail(UserDetail)
    }

    enum Action {
        case userTapped(User.ID)
        case destination(PresentationAction<Destination.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .userTapped(id):
                guard let user = state.users[id: id] else { return .none }
                state.destination = .userDetail(.init(user: user))
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

struct UserListView: View {
    @Bindable var store: StoreOf<UserList>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.users) { user in
                    Text(user.name)
                        .onTapGesture {
                            store.send(.userTapped(user.id))
                        }
                }
            }
            .navigationDestination(
                item: $store.scope(state: \.destination?.userDetail, action: \.destination.userDetail)
            ) { store in
                UserDetailView(store: store)
            }
            .navigationTitle("User List")
        }
    }
}
