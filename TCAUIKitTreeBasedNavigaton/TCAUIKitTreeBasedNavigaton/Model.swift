import Foundation

struct Model {
    static let users: [User] = [
        .init(id: UUID(), name: "Abigail Anderson"),
        .init(id: UUID(), name: "Benjamin Barkley"),
        .init(id: UUID(), name: "Caroline Kingston")
    ]
}

struct User: Equatable, Identifiable {
    let id: UUID
    let name: String
}
