import SwiftUI
import ComposableArchitecture

@Reducer
struct Root {
    @ObservableState
    struct State: Equatable {
        var child1 = Child1.State()
        var child2 = Child2.State()
    }

    enum Action {
        case child1(Child1.Action)
        case child2(Child2.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.child1, action: \.child1) {
            Child1()
        }
        Scope(state: \.child2, action: \.child2) {
            Child2()
        }
        Reduce { _, _ in
            print("Root")
            return .none
        }
    }
}

@Reducer
struct Child1 {
    @ObservableState
    struct State: Equatable {
        var grandChild1 = GrandChild1.State()
    }

    enum Action {
        case grandChild1(GrandChild1.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.grandChild1, action: \.grandChild1) {
            GrandChild1()
        }
        Reduce { _, _ in
            print("Child1")
            return .none
        }
    }
}

@Reducer
struct Child2 {
    @ObservableState
    struct State: Equatable {
        var grandChild2 = GrandChild2.State()
    }

    enum Action {
        case grandChild2(GrandChild2.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.grandChild2, action: \.grandChild2) {
            GrandChild2()
        }
        Reduce { _, _ in
            print("Child2")
            return .none
        }
    }
}

@Reducer
struct GrandChild1 {
    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        case tapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            print("GrandChild1")
            switch action {
            case .tapped:
                return .none
            }
        }
    }
}

@Reducer
struct GrandChild2 {
    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        case tapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            print("GrandChild2")
            switch action {
            case .tapped:
                return .none
            }
        }
    }
}


struct ContentView: View {
    let store = Store(initialState: Root.State()) { Root() }

    var body: some View {
        Button {
            store.send(.child1(.grandChild1(.tapped)))
        } label: {
            Image(systemName: "plus")
            Text("Tap")
        }
    }
}

#Preview {
    ContentView()
}
