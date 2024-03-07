import ComposableArchitecture
import UIKit
import SwiftUI

@Reducer
struct UserList {
    @ObservableState
    struct State {
        var users: IdentifiedArrayOf<User>
        @Presents var destination: Destination.State?

        init(users: [User]) {
            self.users = .init(uniqueElements: users)
        }
    }

    @Reducer
    enum Destination {
        case userDetail(UserDetail)
        case addUser(AddUser)
    }

    enum Action {
        case userTapped(User)
        case addButtonTapped
        case destination(PresentationAction<Destination.Action>)
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .userTapped(user):
                state.destination = .userDetail(.init(user: user))
                return .none

            case .addButtonTapped:
                state.destination = .addUser(.init())
                return .none

            case let .destination(.presented(.addUser(.delegate(.saveUser(text))))):
                state.users.append(User(id: uuid(), name: text))
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

class UserListViewController: UIViewController {
    let store: StoreOf<UserList>
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, UUID>!

    enum Section {
        case main
    }

    init(store: StoreOf<UserList>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ユーザ一覧"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        setupCollectionView()

        var userDetailController: UserDetailViewController?
        var addUserController: AddUserViewController?

        observe { [weak self] in
            guard let self else { return }

            if let destination = store.scope(state: \.destination, action: \.destination.presented) {
                switch destination.case {
                case let .userDetail(store):
                    if userDetailController == nil {
                        userDetailController = UserDetailViewController(store: store)
                        navigationController?.pushViewController(userDetailController!, animated: true)
                    }
                case let .addUser(store):
                    if addUserController == nil {
                        addUserController = AddUserViewController(store: store)
                        present(addUserController!, animated: true)
                    }
                }
            } else if store.destination == nil {
                if userDetailController != nil {
                    navigationController?.popToViewController(self, animated: true)
                    userDetailController = nil
                } else if addUserController != nil {
                    addUserController?.dismiss(animated: true)
                    addUserController = nil
                }
            }
        }

        observe { [weak self] in
            guard let self else { return }

            var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
            snapshot.appendSections([.main])
            snapshot.appendItems(store.users.ids.elements)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isMovingToParent {
            store.send(.destination(.dismiss))
        }
    }

    private func setupCollectionView() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID> { [weak self] (cell, indexPath, item) in
            guard let self else { return }

            var content = cell.defaultContentConfiguration()
            if let user = store.users[id: item] {
                content.text = user.name
            }
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }

    @objc func addButtonTapped() {
        store.send(.addButtonTapped)
    }
}

extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let user = store.users[indexPath.row]
        store.send(.userTapped(user))
    }
}