import SwiftUI
import ComposableArchitecture

struct ObserveTestView: UIViewControllerRepresentable {
    let store: StoreOf<ObserveTest>

    func makeUIViewController(context: Context) -> some UIViewController {
        ObserveTestViewController(store: store)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

@Reducer
struct ObserveTest {
    @ObservableState
    struct State: Equatable {
        var count = 0
    }

    enum Action {
        case incrementButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none
            }
        }
    }
}

class ObserveTestViewController: UIViewController {
    let store: StoreOf<ObserveTest>

    init(store: StoreOf<ObserveTest>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let countLabel = UILabel()

        let incrementButton = UIButton(type: .system)
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        incrementButton.setTitle("+", for: .normal)

        let rootStackView = UIStackView(arrangedSubviews: [
            countLabel,
            incrementButton,
        ])
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootStackView)

        NSLayoutConstraint.activate([
            rootStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rootStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        observe { [weak self] in
            guard let self else { return }
            countLabel.text = "\(store.count)"
        }
    }

    @objc func incrementButtonTapped() {
        store.send(.incrementButtonTapped)
    }
}

#Preview {
    ObserveTestViewController(
        store: Store(initialState: ObserveTest.State()) {
            ObserveTest()
        }
    )
}
