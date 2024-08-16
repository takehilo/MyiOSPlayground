import Foundation
import IdentifiedCollections

struct User: Equatable, Identifiable {
    let id: UserId
    let name: String
    let followers: [UserId]
}

struct UserId: Hashable {
    let rawValue: Int
}

extension User {
    static let users: IdentifiedArrayOf<User> = [
        User(id: UserId(rawValue: 0), name: "Alice", followers: [UserId(rawValue: 1), UserId(rawValue: 3), UserId(rawValue: 5), UserId(rawValue: 7), UserId(rawValue: 9)]),
        User(id: UserId(rawValue: 1), name: "Bob", followers: [UserId(rawValue: 2), UserId(rawValue: 4), UserId(rawValue: 6), UserId(rawValue: 8), UserId(rawValue: 10)]),
        User(id: UserId(rawValue: 2), name: "Charlie", followers: [UserId(rawValue: 3), UserId(rawValue: 5), UserId(rawValue: 7), UserId(rawValue: 9), UserId(rawValue: 11)]),
        User(id: UserId(rawValue: 3), name: "David", followers: [UserId(rawValue: 4), UserId(rawValue: 6), UserId(rawValue: 8), UserId(rawValue: 10), UserId(rawValue: 12)]),
        User(id: UserId(rawValue: 4), name: "Eva", followers: [UserId(rawValue: 5), UserId(rawValue: 7), UserId(rawValue: 9), UserId(rawValue: 11), UserId(rawValue: 13)]),
        User(id: UserId(rawValue: 5), name: "Frank", followers: [UserId(rawValue: 6), UserId(rawValue: 8), UserId(rawValue: 10), UserId(rawValue: 12), UserId(rawValue: 14)]),
        User(id: UserId(rawValue: 6), name: "Grace", followers: [UserId(rawValue: 7), UserId(rawValue: 9), UserId(rawValue: 11), UserId(rawValue: 13), UserId(rawValue: 15)]),
        User(id: UserId(rawValue: 7), name: "Henry", followers: [UserId(rawValue: 8), UserId(rawValue: 10), UserId(rawValue: 12), UserId(rawValue: 14), UserId(rawValue: 16)]),
        User(id: UserId(rawValue: 8), name: "Ivy", followers: [UserId(rawValue: 9), UserId(rawValue: 11), UserId(rawValue: 13), UserId(rawValue: 15), UserId(rawValue: 17)]),
        User(id: UserId(rawValue: 9), name: "Jack", followers: [UserId(rawValue: 10), UserId(rawValue: 12), UserId(rawValue: 14), UserId(rawValue: 16), UserId(rawValue: 18)]),
        User(id: UserId(rawValue: 10), name: "Kevin", followers: [UserId(rawValue: 11), UserId(rawValue: 13), UserId(rawValue: 15), UserId(rawValue: 17), UserId(rawValue: 19)]),
        User(id: UserId(rawValue: 11), name: "Lucy", followers: [UserId(rawValue: 12), UserId(rawValue: 14), UserId(rawValue: 16), UserId(rawValue: 18), UserId(rawValue: 20)]),
        User(id: UserId(rawValue: 12), name: "Mike", followers: [UserId(rawValue: 13), UserId(rawValue: 15), UserId(rawValue: 17), UserId(rawValue: 19), UserId(rawValue: 21)]),
        User(id: UserId(rawValue: 13), name: "Nancy", followers: [UserId(rawValue: 14), UserId(rawValue: 16), UserId(rawValue: 18), UserId(rawValue: 20), UserId(rawValue: 22)]),
        User(id: UserId(rawValue: 14), name: "Olivia", followers: [UserId(rawValue: 15), UserId(rawValue: 17), UserId(rawValue: 19), UserId(rawValue: 21), UserId(rawValue: 23)]),
        User(id: UserId(rawValue: 15), name: "Peter", followers: [UserId(rawValue: 16), UserId(rawValue: 18), UserId(rawValue: 20), UserId(rawValue: 22), UserId(rawValue: 24)]),
        User(id: UserId(rawValue: 16), name: "Queenie", followers: [UserId(rawValue: 17), UserId(rawValue: 19), UserId(rawValue: 21), UserId(rawValue: 23), UserId(rawValue: 25)]),
        User(id: UserId(rawValue: 17), name: "Roger", followers: [UserId(rawValue: 18), UserId(rawValue: 20), UserId(rawValue: 22), UserId(rawValue: 24), UserId(rawValue: 0)]),
        User(id: UserId(rawValue: 18), name: "Samantha", followers: [UserId(rawValue: 19), UserId(rawValue: 21), UserId(rawValue: 23), UserId(rawValue: 25), UserId(rawValue: 1)]),
        User(id: UserId(rawValue: 19), name: "Tom", followers: [UserId(rawValue: 20), UserId(rawValue: 22), UserId(rawValue: 24), UserId(rawValue: 0), UserId(rawValue: 2)]),
        User(id: UserId(rawValue: 20), name: "Ursula", followers: [UserId(rawValue: 21), UserId(rawValue: 23), UserId(rawValue: 25), UserId(rawValue: 1), UserId(rawValue: 3)]),
        User(id: UserId(rawValue: 21), name: "Victor", followers: [UserId(rawValue: 22), UserId(rawValue: 24), UserId(rawValue: 0), UserId(rawValue: 2), UserId(rawValue: 4)]),
        User(id: UserId(rawValue: 22), name: "Wendy", followers: [UserId(rawValue: 23), UserId(rawValue: 25), UserId(rawValue: 1), UserId(rawValue: 3), UserId(rawValue: 5)]),
        User(id: UserId(rawValue: 23), name: "Xander", followers: [UserId(rawValue: 24), UserId(rawValue: 0), UserId(rawValue: 2), UserId(rawValue: 4), UserId(rawValue: 6)]),
        User(id: UserId(rawValue: 24), name: "Yara", followers: [UserId(rawValue: 25), UserId(rawValue: 1), UserId(rawValue: 3), UserId(rawValue: 5), UserId(rawValue: 7)]),
        User(id: UserId(rawValue: 25), name: "Zack", followers: [UserId(rawValue: 0), UserId(rawValue: 2), UserId(rawValue: 4), UserId(rawValue: 6), UserId(rawValue: 8)])
    ]
}
