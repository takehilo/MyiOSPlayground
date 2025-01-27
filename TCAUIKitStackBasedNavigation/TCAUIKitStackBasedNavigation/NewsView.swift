import SwiftUI
import ComposableArchitecture

@Reducer
struct News {
    @ObservableState
    struct State: Equatable {
    }

    enum Action {
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            .none
        }
    }
}

class NewsViewController: UIViewController {
    let store: StoreOf<News>

    init(store: StoreOf<News>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "ニュース"

        let rootStackView = UIStackView(arrangedSubviews: [
            label
        ])
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootStackView)

        NSLayoutConstraint.activate([
            rootStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rootStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}
