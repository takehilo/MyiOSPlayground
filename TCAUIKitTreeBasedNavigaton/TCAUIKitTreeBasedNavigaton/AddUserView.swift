import ComposableArchitecture
import SwiftUI

@Reducer
struct AddUser {
    @ObservableState
    struct State: Equatable {
    }

    enum Action {
        case saveButtonTapped(String)
        case closeButtonTapped
        case delegate(Delegate)

        enum Delegate {
            case saveUser(String)
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .saveButtonTapped(text):
                return .run { send in
                    await send(.delegate(.saveUser(text)))
                    await dismiss()
                }

            case .closeButtonTapped:
                return .run { _ in await dismiss() }

            case .delegate:
                return .none
            }
        }
    }
}

class AddUserViewController: UIViewController {
    let store: StoreOf<AddUser>
    let textField = UITextField()

    init(store: StoreOf<AddUser>) {
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

        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: 200).isActive = true

        let saveButton = UIButton(type: .system)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.setTitle("Save", for: .normal)

        let closeButton = UIButton(type: .system)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.setTitle("Close", for: .normal)

        let rootStackView = UIStackView(arrangedSubviews: [
            textField,
            saveButton,
            closeButton
        ])
        rootStackView.axis = .vertical
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootStackView)

        NSLayoutConstraint.activate([
            rootStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rootStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func saveButtonTapped() {
        if let text = textField.text {
            store.send(.saveButtonTapped(text))
        }
    }

    @objc func closeButtonTapped() {
        store.send(.closeButtonTapped)
    }
}
