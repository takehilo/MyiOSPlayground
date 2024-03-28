import SwiftUI
import SharedModel
import AppFeature
import ComposableArchitecture

@main
struct XcodeGenWithLocalPackageApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State(user: User(name: "alice"))
                ) {
                    AppFeature()
                }
            )
        }
    }
}
