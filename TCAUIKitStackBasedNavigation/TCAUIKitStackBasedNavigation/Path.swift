import ComposableArchitecture

@Reducer(state: .equatable)
enum Path {
    case news(News)
    case movie(Movie)
}

@CasePathable
enum PathDto: Equatable {
    case news(News)
    case movie(Movie)

    struct News: Equatable {
    }

    struct Movie: Equatable {
    }
}
