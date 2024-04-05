import SwiftUI
import ComposableArchitecture
import UserListFeature
import SharedModel

@Reducer
public struct AppReducer {
    @ObservableState
    public struct State {
        public var userList = UserList.State(users: User.users)

        public init() {}
    }

    public enum Action {
        case userList(UserList.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.userList, action: \.userList) {
            UserList()
        }
        Reduce { state, action in
            .none
        }
    }
}

public struct AppView: UIViewControllerRepresentable {
    let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        AppViewController(store: store)
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class AppViewController: UINavigationController {
    let store: StoreOf<AppReducer>

    init(store: StoreOf<AppReducer>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let rootController = UserListViewController(
            store: store.scope(state: \.userList, action: \.userList)
        )
        setViewControllers([rootController], animated: false)
    }
}
