import SwiftUI
import ComposableArchitecture

@main
struct TCAUIKitObserveApp: App {
    var body: some Scene {
        WindowGroup {
            ObserveTestView(
                store: Store(initialState: ObserveTest.State()) {
                    ObserveTest()
                }
            )
//            CounterView(model: CounterModel())
//            CounterViewWithoutMacro(model: CounterModelWithoutMacro())
        }
    }
}
