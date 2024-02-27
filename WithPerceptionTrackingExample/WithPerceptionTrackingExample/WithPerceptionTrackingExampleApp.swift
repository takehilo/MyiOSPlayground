import SwiftUI
import ComposableArchitecture

@main
struct WithPerceptionTrackingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: Content.State()) {
                    Content()
                }
            )
//            ForEachView(
//                store: Store(initialState: ForEachFeature.State()) {
//                    ForEachFeature()
//                }
//            )
        }
    }
}
