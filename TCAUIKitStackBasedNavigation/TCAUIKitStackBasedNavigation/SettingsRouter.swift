import SwiftUI
import ComposableArchitecture

@Reducer
struct SettingsRouter {
    @ObservableState
    struct State {
        @Shared(.settingsPathType) var settingsPathType
        var home = Settings.State()
        var path = StackState<Path.State>()
    }

    enum Action: ViewAction {
        case view(View)
        case _internal(Internal)
        case path(StackActionOf<Path>)
        case home(Settings.Action)

        enum View {
            case viewDidLoad
        }

        enum Internal {
            case pathTypeChanged
        }
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            Settings()
        }
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .viewDidLoad:
                    return .publisher {
                        state.$settingsPathType
                            .publisher
                            .dropFirst()
                            .map { _ in Action._internal(.pathTypeChanged) }
                    }
                }
            case let ._internal(internalAction):
                switch internalAction {
                case .pathTypeChanged:
                    if let pathType = state.settingsPathType {
                        switch pathType {
                        case .news:
                            state.path.append(.news(.init(pathType: state.$settingsPathType)))
                        case .movie:
                            state.path.append(.movie(.init(pathType: state.$settingsPathType)))
                        }
                        state.$settingsPathType.withLock { $0 = nil }
                    }
                    return .none
                }
            case .path:
                return .none
            case .home:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        ._printChanges()
    }
}

class SettingsRouterController: NavigationStackController {
    var store: StoreOf<SettingsRouter>!

    convenience init(store: StoreOf<SettingsRouter>) {
        @UIBindable var store = store

        self.init(path: $store.scope(state: \.path, action: \.path)) {
            SettingsViewController(store: store.scope(state: \.home, action: \.home))
        } destination: { store in
            let vc: UIViewController = {
                switch store.case {
                case let .news(store):
                    NewsViewController(store: store)
                case let .movie(store):
                    MovieViewController(store: store)
                }
            }()
            return vc
        }

        self.store = store
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        store.send(.view(.viewDidLoad))
    }
}
