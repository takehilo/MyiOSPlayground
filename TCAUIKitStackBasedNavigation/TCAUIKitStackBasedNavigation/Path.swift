import ComposableArchitecture

@Reducer(state: .equatable)
enum Path {
    case news(News)
    case movie(Movie)
}

@CasePathable
enum PathType: Equatable {
    case news(NewsPath)
    case movie(MoviePath)

    struct NewsPath: Equatable {
    }

    struct MoviePath: Equatable {
    }
}
