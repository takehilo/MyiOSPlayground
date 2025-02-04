import SwiftUI
import ComposableArchitecture

@Reducer
struct Movie {
    @ObservableState
    struct State: Equatable {
//        @Shared(.pathType) var pathType
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
//                    state.$pathType.withLock { $0 = .news(.init()) }
                    return .none
                case .movieButtonTapped:
//                    state.$pathType.withLock { $0 = .movie(.init()) }
                    return .none
                }
            }
        }
    }
}

@ViewAction(for: Movie.self)
class MovieViewController: UIViewController {
    let store: StoreOf<Movie>

    init(store: StoreOf<Movie>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "動画"

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

