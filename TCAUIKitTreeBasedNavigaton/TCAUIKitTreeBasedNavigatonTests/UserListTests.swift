import XCTest
import ComposableArchitecture
@testable import TCAUIKitTreeBasedNavigaton

class UserListTests: XCTestCase {
    @MainActor
    func testAddUser() async {
        let store = TestStore(initialState: UserList.State(users: [])) {
            UserList()
        }

        await store.send(\.addButtonTapped) {
            $0.destination = .addUser(.init())
        }
        await store.send(\.destination.presented.addUser.saveButtonTapped, "New User")
        await store.receive(\.destination.presented.addUser.delegate.saveUser) {
            $0.users = .init(uniqueElements: [User(id: UserId(rawValue: 0), name: "New User", followers: [])])
        }
        await store.receive(\.destination.addUser.dismiss) {
            $0.destination = nil
        }
    }

    @MainActor
    func testTapUser() async {
        let store = TestStore(initialState: UserList.State(users: [
            User(id: UserId(rawValue: 0), name: "User0", followers: []),
            User(id: UserId(rawValue: 1), name: "User1", followers: [])
        ])) {
            UserList()
        }

        await store.send(\.userTapped, UserId(rawValue: 0)) {
            $0.destination = .userDetail(UserDetail.State(user: User(id: UserId(rawValue: 0), name: "User0", followers: [])))
        }
    }
}
