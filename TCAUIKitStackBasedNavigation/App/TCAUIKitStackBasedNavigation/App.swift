import SwiftUI
import ComposableArchitecture
import AppFeature

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
