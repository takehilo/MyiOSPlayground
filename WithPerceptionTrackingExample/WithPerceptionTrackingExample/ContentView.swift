import SwiftUI
import ComposableArchitecture

@Reducer
struct Content {
    @ObservableState
    struct State: Equatable {
        var flag = false
    }

    enum Action {
        case tapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapped:
                state.flag.toggle()
                return .none
            }
        }
    }
}


struct ContentView: View {
    let store: StoreOf<Content>

    var body: some View {
        WithPerceptionTracking {
            // ワーニング出る
//            GeometryReader { geometry in
//                VStack {
//                    Button {
//                        store.send(.tapped)
//                    } label: {
//                        Text("Tap!")
//                    }
//                    Text(store.flag ? "True" : "False")
//                }
//            }

            // ワーニング出ない
            contentWithGeometryReader

            // ワーニング出る
//            GeometryReader { geometry in
//                content
//            }
        }
    }

    var contentWithGeometryReader: some View {
        GeometryReader { geometry in
            VStack {
                Button {
                    store.send(.tapped)
                } label: {
                    Text("Tap!")
                }
                Text(store.flag ? "True" : "False")
            }
        }
    }

    var content: some View {
        VStack {
            Button {
                store.send(.tapped)
            } label: {
                Text("Tap!")
            }
            Text(store.flag ? "True" : "False")
        }
    }
}

#Preview {
    ContentView(
        store: Store(initialState: Content.State()) {
            Content()
        }
    )
}
