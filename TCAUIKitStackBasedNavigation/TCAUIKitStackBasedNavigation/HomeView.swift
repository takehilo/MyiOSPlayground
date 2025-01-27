import SwiftUI
import ComposableArchitecture

@Reducer
struct Home {
    @ObservableState
    struct State {
        @Shared(.homeRouterPath) var path
    }

    enum Action: ViewAction {
        case view(View)

        enum View {
            case newsButtonTapped
            case movieButtonTapped
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .newsButtonTapped:
                    state.$path.withLock { $0.append(.news(.init())) }
                    return .none
                case .movieButtonTapped:
                    state.$path.withLock { $0.append(.movie(.init())) }
                    return .none
                }
            }
        }
    }
}

@ViewAction(for: Home.self)
class HomeViewController: UIViewController {
    let store: StoreOf<Home>

    init(store: StoreOf<Home>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let newsButton = UIButton(type: .system)
        newsButton.addAction(UIAction { _ in self.send(.newsButtonTapped) }, for: .touchUpInside)
        newsButton.setTitle("ニュース", for: .normal)

        let movieButton = UIButton(type: .system)
        movieButton.addAction(UIAction { _ in self.send(.movieButtonTapped) }, for: .touchUpInside)
        movieButton.setTitle("動画", for: .normal)

        let rootStackView = UIStackView(arrangedSubviews: [
            newsButton,
            movieButton
        ])
        rootStackView.axis = .vertical
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootStackView)

        NSLayoutConstraint.activate([
          rootStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
          rootStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}
