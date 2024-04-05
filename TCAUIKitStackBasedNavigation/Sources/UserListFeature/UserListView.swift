import ComposableArchitecture
import UIKit
import SwiftUI
//import UserDetailFeature
import SharedModel

@Reducer
public struct UserList {
    @ObservableState
    public struct State: Equatable {
        public var users: IdentifiedArrayOf<User>
        @Presents public var destination: Destination.State?

        public init(users: IdentifiedArrayOf<User>) {
            self.users = users
        }
    }

    @Reducer(state: .equatable)
    public enum Destination {
//        case userDetail(UserDetail)
    }

    public enum Action {
        case userTapped(User.ID)
        case destination(PresentationAction<Destination.Action>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .userTapped(id):
                guard let user = state.users[id: id] else { return .none }
//                state.destination = .userDetail(.init(user: user))
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

public class UserListViewController: UIViewController {
    let store: StoreOf<UserList>
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, UserId>!

    enum Section {
        case main
    }

    public init(store: StoreOf<UserList>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "ユーザ一覧"

        setupCollectionView()

//        var userDetailController: UserDetailViewController?
//
//        observe { [weak self] in
//            guard let self else { return }
//
//            if let userDetail = store.scope(state: \.destination?.userDetail, action: \.destination.presented.userDetail),
//               userDetailController == nil
//            {
//                userDetailController = UserDetailViewController(store: userDetail)
//                navigationController?.pushViewController(userDetailController!, animated: true)
//            } else if store.destination?.userDetail == nil, userDetailController != nil {
//                navigationController?.popToViewController(self, animated: true)
//                userDetailController = nil
//            }
//        }

        observe { [weak self] in
            guard let self else { return }

            var snapshot = NSDiffableDataSourceSnapshot<Section, UserId>()
            snapshot.appendSections([.main])
            snapshot.appendItems(store.users.ids.elements)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
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

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UserId> { [weak self] (cell, indexPath, item) in
            guard let self else { return }

            var content = cell.defaultContentConfiguration()
            if let user = store.users[id: item] {
                content.text = user.name
            }
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource<Section, UserId>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
}

extension UserListViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let user = store.users[indexPath.row]
        store.send(.userTapped(user.id))
    }
}
