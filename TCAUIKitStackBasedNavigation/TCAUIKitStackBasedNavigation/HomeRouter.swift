import SwiftUI
import ComposableArchitecture

@Reducer
struct HomeRouter {
    @ObservableState
    struct State {
        @Shared(.homeRouterPath) var path
        var home = Home.State()
    }

    @Reducer(state: .equatable)
    enum Path {
        case news(News)
        case movie(Movie)
    }

    enum Action {
        case path(StackActionOf<Path>)
        case home(Home.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            Home()
        }
        Reduce { state, action in
            .none
        }
        .forEach(\.path, action: \.path)
    }
}

class HomeRouterController: NavigationStackController {
    private var store: StoreOf<HomeRouter>!

    convenience init(store: StoreOf<HomeRouter>) {
        @UIBindable var store = store

        self.init(path: $store.scope(state: \.path, action: \.path)) {
            HomeViewController(store: store.scope(state: \.home, action: \.home))
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

extension SharedReaderKey where Self == InMemoryKey<StackState<HomeRouter.Path.State>> {
    static var homeRouterPath: Self {
        inMemory("homeRouterPath")
    }
}

extension SharedReaderKey where Self == InMemoryKey<StackState<HomeRouter.Path.State>>.Default {
    static var homeRouterPath: Self {
        Self[.homeRouterPath, default: .init()]
    }
}
