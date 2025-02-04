import SwiftUI
import ComposableArchitecture

@Reducer
struct HomeRouter {
    @ObservableState
    struct State {
        @Shared(.homePathDto) var homePathDto
        var home = Home.State()
        var path = StackState<Path.State>()
    }

    enum Action: ViewAction {
        case view(View)
        case _internal(Internal)
        case path(StackActionOf<Path>)
        case home(Home.Action)

        enum View {
            case viewDidLoad
        }

        enum Internal {
            case pathDtoChanged
        }
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            Home()
        }
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .viewDidLoad:
                    return .publisher {
                        state.$homePathDto
                            .publisher
                            .dropFirst()
                            .map { _ in Action._internal(.pathDtoChanged) }
                    }
                }
            case let ._internal(internalAction):
                switch internalAction {
                case .pathDtoChanged:
                    if let pathDto = state.homePathDto {
                        switch pathDto {
                        case .news:
                            state.path.append(.news(.init(pathDto: state.$homePathDto)))
                        case .movie:
                            state.path.append(.movie(.init(pathDto: state.$homePathDto)))
                        }
                        state.$homePathDto.withLock { $0 = nil }
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

class HomeRouterController: NavigationStackController {
    var store: StoreOf<HomeRouter>!

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

    override func viewDidLoad() {
        super.viewDidLoad()
        store.send(.view(.viewDidLoad))
    }
}

extension SharedReaderKey where Self == InMemoryKey<PathDto?> {
    static var homePathDto: Self {
        inMemory("homePathDto")
    }
}

extension SharedReaderKey where Self == InMemoryKey<PathDto?>.Default {
    static var homePathDto: Self {
        Self[.homePathDto, default: nil]
    }
}
