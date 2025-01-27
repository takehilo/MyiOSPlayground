import SwiftUI
import ComposableArchitecture

@Reducer
struct SettingsRouter {
    @ObservableState
    struct State {
        @Shared(.settingsRouterPath) var path
        var settings = Settings.State()
    }

    @Reducer(state: .equatable)
    enum Path {
        case news(News)
        case movie(Movie)
    }

    enum Action {
        case path(StackActionOf<Path>)
        case settings(Settings.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.settings, action: \.settings) {
            Settings()
        }
        Reduce { state, action in
            .none
        }
        .forEach(\.path, action: \.path)
    }
}

class SettingsRouterController: NavigationStackController {
    private var store: StoreOf<SettingsRouter>!

    convenience init(store: StoreOf<SettingsRouter>) {
        @UIBindable var store = store

        self.init(path: $store.scope(state: \.path, action: \.path)) {
            SettingsViewController(store: store.scope(state: \.settings, action: \.settings))
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
}

extension SharedReaderKey where Self == InMemoryKey<StackState<SettingsRouter.Path.State>> {
    static var settingsRouterPath: Self {
        inMemory("settingsRouterPath")
    }
}

extension SharedReaderKey where Self == InMemoryKey<StackState<SettingsRouter.Path.State>>.Default {
    static var settingsRouterPath: Self {
        Self[.settingsRouterPath, default: .init()]
    }
}
