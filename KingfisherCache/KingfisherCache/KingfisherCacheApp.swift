import SwiftUI
import Kingfisher

@main
struct KingfisherCacheApp: App {
    init() {
        let cacheKey = "https://placehold.jp/150x150.png"
        let cache = ImageCache.default

        KingfisherManager.shared.defaultOptions.append(.diskCacheAccessExtendingExpiration(.none))
        cache.diskStorage.config.expiration = .seconds(10)

        print(cache.isCached(forKey: cacheKey))
        print(cache.imageCachedType(forKey: cacheKey))
        print(cache.diskStorage.config.expiration)

//        cache.removeImage(forKey: cacheKey)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
