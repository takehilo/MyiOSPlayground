import SwiftUI
import ComposableArchitecture

@Reducer
struct AppReducer {
    @ObservableState
    struct State {
        var homeRouter = HomeRouter.State()
        var settingsRouter = SettingsRouter.State()
    }

    enum Action {
        case homeRouter(HomeRouter.Action)
        case settingsRouter(SettingsRouter.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.homeRouter, action: \.homeRouter) {
            HomeRouter()
        }
        Scope(state: \.settingsRouter, action: \.settingsRouter) {
            SettingsRouter()
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

class AppViewController: UITabBarController {
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
        let home = HomeRouterController(store: store.scope(state: \.homeRouter, action: \.homeRouter))
        home.tabBarItem = UITabBarItem(title: "ホーム", image: UIImage(systemName: "house"), tag: 0)
        let settings = SettingsRouterController(store: store.scope(state: \.settingsRouter, action: \.settingsRouter))
        settings.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gearshape"), tag: 1)
        setViewControllers([home, settings], animated: false)
    }
}
