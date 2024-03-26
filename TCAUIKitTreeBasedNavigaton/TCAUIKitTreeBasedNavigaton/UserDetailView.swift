import ComposableArchitecture
import SwiftUI

@Reducer
struct UserDetail {
    @ObservableState
    struct State: Equatable {
        let user: User
        @Presents var destination: Destination.State?
    }

    @Reducer(state: .equatable)
    enum Destination {
        case userDetail(UserDetail)
    }

    enum Action {
        case userTapped(User.ID)
        case destination(PresentationAction<Destination.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .userTapped(id):
                guard let user = User.users[id: id] else { return .none }
                state.destination = .userDetail(.init(user: user))
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

class UserDetailViewController: UIViewController {
    let store: StoreOf<UserDetail>
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, UserId>!

    enum Section {
        case user
        case follower
    }

    init(store: StoreOf<UserDetail>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ユーザ詳細"
        
        setupCollectionView()

        var userDetailController: UserDetailViewController?

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
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isMovingToParent, store.destination != nil {
            store.send(.destination(.dismiss))
        }
    }

    private func setupCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
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

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UserId> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = User.users[id: item]?.name ?? ""
            cell.contentConfiguration = content
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            var content = supplementaryView.defaultContentConfiguration()
            content.text = indexPath.section == 0 ? "User" : "Followers"
            supplementaryView.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource<Section, UserId>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: UserId) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        dataSource.supplementaryViewProvider = { (view, kind, index) in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, UserId>()
        snapshot.appendSections([.user, .follower])
        snapshot.appendItems([store.user.id], toSection: .user)
        snapshot.appendItems(store.user.followers, toSection: .follower)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension UserDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard indexPath.section != 0 else { return }

        let userId = store.user.followers[indexPath.row]
        store.send(.userTapped(userId))
    }
}
