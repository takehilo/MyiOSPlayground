import ComposableArchitecture

protocol OpenLoggableState {
    var message: String { get }
}

enum OpenAction {
    case onAppear
}

protocol OpenLoggableAction {
    static func open(_ action: OpenAction) -> Self
    var open: OpenAction? { get }
}

extension OpenLoggableAction {
    var open: OpenAction? {
        AnyCasePath(unsafe: { .open($0) }).extract(from: self)
    }
}

struct OpenLoggingReducer<State, Action: OpenLoggableAction>: Reducer where State: OpenLoggableState {
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        guard let openAction = action.open else { return .none }

        switch openAction {
        case .onAppear:
            print(state.message)
            return .none
        }
    }
}
