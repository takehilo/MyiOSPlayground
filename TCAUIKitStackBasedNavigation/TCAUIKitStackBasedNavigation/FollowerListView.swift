import ComposableArchitecture
import UIKit
import SwiftUI

@Reducer
public struct FollowerList {
    @ObservableState
    public struct State: Equatable {
        public let user: User
        @Presents var destination: Destination.State?

        public init(user: User) {
            self.user = user
        }
    }

    @Reducer(state: .equatable)
    public enum Destination {
        case userDetail(UserDetail)
    }

    public enum Action {
        case userTapped(User.ID)
        case destination(PresentationAction<Destination.Action>)
    }

    public var body: some ReducerOf<Self> {
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

class FollowerListViewController: UIViewController {
    let store: StoreOf<FollowerList>
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, UserId>!

    enum Section {
        case main
    }

    init(store: StoreOf<FollowerList>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(store.user.name)のフォロワー一覧"

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

        observe { [weak self] in
            guard let self else { return }

            var snapshot = NSDiffableDataSourceSnapshot<Section, UserId>()
            snapshot.appendSections([.main])
            snapshot.appendItems(store.user.followers)
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

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UserId> { [weak self] (cell, indexPath, item) in
            guard let self else { return }

            var content = cell.defaultContentConfiguration()
            if let user = User.users[id: item] {
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

extension FollowerListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let userId = store.user.followers[indexPath.row]
        store.send(.userTapped(userId))
    }
}

