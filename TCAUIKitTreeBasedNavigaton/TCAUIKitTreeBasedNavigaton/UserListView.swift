import ComposableArchitecture
import UIKit
import SwiftUI

@Reducer
struct UserList {
    @ObservableState
    struct State: Equatable {
        var users: IdentifiedArrayOf<User>
        @Presents var destination: Destination.State?

        init(users: [User]) {
            self.users = .init(uniqueElements: users)
        }
    }

    @Reducer(state: .equatable)
    enum Destination {
        case userDetail(UserDetail)
        case addUser(AddUser)
    }

    enum Action {
        case userTapped(User.ID)
        case addButtonTapped
        case destination(PresentationAction<Destination.Action>)
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .userTapped(id):
                guard let user = state.users[id: id] else { return .none }
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

            if let userDetail = store.scope(state: \.destination?.userDetail, action: \.destination.presented.userDetail),
               userDetailController == nil
            {
                userDetailController = UserDetailViewController(store: userDetail)
                navigationController?.pushViewController(userDetailController!, animated: true)
            } else if store.destination?.userDetail == nil, userDetailController != nil {
                navigationController?.popToViewController(self, animated: true)
                userDetailController = nil
            }

            if let addUser = store.scope(state: \.destination?.addUser, action: \.destination.presented.addUser),
               addUserController == nil
            {
                addUserController = AddUserViewController(store: addUser)
                present(addUserController!, animated: true)
            } else if store.destination?.addUser == nil, addUserController != nil {
                addUserController?.dismiss(animated: true)
                addUserController = nil
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

        if !isMovingToParent, store.destination != nil {
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
        store.send(.userTapped(user.id))
    }
}
