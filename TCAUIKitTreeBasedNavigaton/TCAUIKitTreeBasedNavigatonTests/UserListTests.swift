import XCTest
import ComposableArchitecture
@testable import TCAUIKitTreeBasedNavigaton

@MainActor
class UserListTests: XCTestCase {
    func testAddUser() async throws {
        let store = TestStore(initialState: UserList.State(users: [])) {
            UserList()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(\.addButtonTapped) {
            $0.destination = .addUser(.init())
        }
        await store.send(\.destination.presented.addUser.saveButtonTapped, "New User")
        await store.receive(\.destination.presented.addUser.delegate.saveUser) {
            $0.users = .init(uniqueElements: [User(id: UUID(0), name: "New User")])
        }
        await store.receive(\.destination.addUser.dismiss) {
            $0.destination = nil
        }
    }

    func testTapUser() async throws {
        let store = TestStore(initialState: UserList.State(users: [
            User(id: UUID(0), name: "User0"),
            User(id: UUID(1), name: "User1")
        ])) {
            UserList()
        }

        await store.send(\.userTapped, UUID(0)) {
            $0.destination = .userDetail(UserDetail.State(user: User(id: UUID(0), name: "User0")))
        }
    }
}
