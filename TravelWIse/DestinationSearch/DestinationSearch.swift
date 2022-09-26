import ComposableArchitecture
import Combine
import Foundation

enum DestinationSearch {
    struct State: Equatable {
        var destinations: [Destination]? = nil
        var fetchFailed: Bool = false
        var likes: [Destination] = []
        var unlikes: [Destination] = []
    }
    
    enum Action: Equatable {
        case fetchDestinations(Result<Destinations?, Never>)
        case viewAppear
        case didLike(Destination)
        case didUnlike(Destination)
        case removeDest(Int)
    }
    
    struct Environment {
        var firebaseDestinations: () -> Effect<Destinations?, Never>
        var mainQueue: () -> AnySchedulerOf<DispatchQueue> = {.main}
    }
    
    static let reducer: Reducer<State, Action, Environment> =
    Reducer {state, action, environment in
        switch action {
        case .viewAppear:
            return environment.firebaseDestinations()
                .receive(on: environment.mainQueue())
                .catchToEffect()
                .map(Action.fetchDestinations)
        case .fetchDestinations(let result):
            print(result)
            switch result {
            case .success(let res):
                state.destinations = res?.data
            case .failure(let t):
                state.fetchFailed = true
            }
        case .didLike(let dest):
            state.likes.append(dest)
        case .didUnlike(let dest):
            state.unlikes.append(dest)
        case .removeDest(let id):
            state.destinations?.removeAll { $0.id == id }
            return .none
        }
        return .none
    }
}
