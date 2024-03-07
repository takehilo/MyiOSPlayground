import SwiftUI
import ComposableArchitecture

@main
struct TCAUIKitTreeBasedNavigatonApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(initialState: AppReducer.State()) {
                    AppReducer()
                }
            )
        }
    }
}
