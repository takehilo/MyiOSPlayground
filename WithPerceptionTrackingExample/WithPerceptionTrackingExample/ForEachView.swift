import SwiftUI
import ComposableArchitecture

@Reducer
struct ForEachFeature {
    @ObservableState
    struct State: Equatable {
        var items: IdentifiedArrayOf<Item.State> = .init(uniqueElements: [Item.State(id: 0), Item.State(id: 1)])
    }

    enum Action {
        case tapped
        case items(IdentifiedActionOf<Item>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapped:
                state.items.append(.init(id: state.items.count))
                return .none
            case .items:
                return .none
            }
        }
        .forEach(\.items, action: \.items) {
            Item()
        }
    }
}

@Reducer
struct Item {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: Int
        var text = ""
    }

    enum Action {
        case tapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapped:
                state.text = "Tapped!"
                return .none
            }
        }
    }

}

struct ForEachView: View {
    let store: StoreOf<ForEachFeature>

    var body: some View {
        WithPerceptionTracking {
            List {
                Button {
                    store.send(.tapped)
                } label: {
                    Text("Tap!")
                }
                ForEach(store.scope(state: \.items, action: \.items), id: \.state.id) { itemStore in
                    WithPerceptionTracking {
                        Text("\(itemStore.id) \(itemStore.text)")
                            .onTapGesture {
                                itemStore.send(.tapped)
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    ForEachView(
        store: Store(initialState: ForEachFeature.State()) {
            ForEachFeature()
        }
    )
}
