# Kingfisherのキャッシュの仕組みメモ

## キャッシュキー
デフォルトでは`URL.absoluteString`の値がキーとして使われる。

## ディスクストレージの有効期限
ディスクストレージの有効期限のデフォルトは`7日間`。

コードはここ:
- DiskStorage.Config.expiration
- https://github.com/onevcat/Kingfisher/blob/7.12.0/Sources/Cache/DiskStorage.swift#L459

以下のようにすることで変更が可能。  
なお、変更前にキャッシュしたものについては、キャッシュ時点での有効期限の値が使用される。

```swift
ImageCache.default.diskStorage.config.expiration = .seconds(10)
```

有効期限には延長の仕組みがある。  
キャッシュにアクセスすると、デフォルトでは有効期限が7日間延長される（キャッシュ時点での有効期限期間によって変わる）。  
以下のようにすることで、延長しないようにすることができる。    
なお、この変更はすでにキャッシュ済みのものにも適用される。

```swift
KingfisherManager.shared.defaultOptions.append(.diskCacheAccessExtendingExpiration(.none))
```

参考:
- https://github.com/onevcat/Kingfisher/discussions/2071
- https://github.com/onevcat/Kingfisher/discussions/2087
