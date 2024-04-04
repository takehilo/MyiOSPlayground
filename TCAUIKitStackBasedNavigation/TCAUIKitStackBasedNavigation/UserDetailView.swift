import ComposableArchitecture
import SwiftUI

@Reducer
public struct UserDetail {
    @ObservableState
    public struct State: Equatable {
        public let user: User
        @Presents public var destination: Destination.State?
    }

    @Reducer(state: .equatable)
    public enum Destination {
        case followerList(FollowerList)
    }

    public enum Action {
        case goToFollowerListTapped
        case destination(PresentationAction<Destination.Action>)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .goToFollowerListTapped:
                state.destination = .followerList(.init(user: state.user))
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
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!

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

        var followerListController: FollowerListViewController?

        observe { [weak self] in
            guard let self else { return }

            if let followerList = store.scope(state: \.destination?.followerList, action: \.destination.presented.followerList),
               followerListController == nil
            {
                followerListController = FollowerListViewController(store: followerList)
                navigationController?.pushViewController(followerListController!, animated: true)
            } else if store.destination?.followerList == nil, followerListController != nil {
                navigationController?.popToViewController(self, animated: true)
                followerListController = nil
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

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> {
            [weak self] (cell, indexPath, item) in
            guard let self else { return }

            var content = cell.defaultContentConfiguration()
            if item == 0 {
                content.text = "\(self.store.user.name)"
            } else if item == 1 {
                content.text = "フォロワー一覧"
            }
            cell.contentConfiguration = content
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            var content = supplementaryView.defaultContentConfiguration()
            content.text = indexPath.section == 0 ? "User" : nil
            supplementaryView.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        dataSource.supplementaryViewProvider = { (view, kind, index) in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.user, .follower])
        snapshot.appendItems([0], toSection: .user)
        snapshot.appendItems([1], toSection: .follower)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension UserDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if indexPath.section == 1 {
            store.send(.goToFollowerListTapped)
        }
    }
}
