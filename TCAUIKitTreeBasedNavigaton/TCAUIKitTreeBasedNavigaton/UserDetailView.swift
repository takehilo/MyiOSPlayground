import ComposableArchitecture
import SwiftUI

@Reducer
struct UserDetail {
    @ObservableState
    struct State: Equatable {
        let user: User
    }
}

class UserDetailViewController: UIViewController {
    let store: StoreOf<UserDetail>

    init(store: StoreOf<UserDetail>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        isModalInPresentation = true

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        observe { [weak self] in
            guard let self else { return }
            label.text = store.user.name
        }
    }
}
