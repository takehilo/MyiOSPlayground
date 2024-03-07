import SwiftUI
import ComposableArchitecture

@Reducer
struct AppReducer {
    @ObservableState
    struct State {
        var userList = UserList.State(users: Model.users)
    }

    enum Action {
        case userList(UserList.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.userList, action: \.userList) {
            UserList()
        }
        Reduce { state, action in
            .none
        }
    }
}

struct AppView: UIViewControllerRepresentable {
    let store: StoreOf<AppReducer>

    func makeUIViewController(context: Context) -> some UIViewController {
        AppViewController(store: store)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
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
