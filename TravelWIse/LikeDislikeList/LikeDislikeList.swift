import Foundation
import ComposableArchitecture

enum LikeDislikeList{
    struct State: Equatable {
        let type: ListType
        let list: [Destination]
    }
    
    enum Action: Equatable {
        
    }
    
    struct Environment {
        var mainQueue: () -> AnySchedulerOf<DispatchQueue> = {.main}
    }
    
    static let reducer: Reducer<State, Action, Environment> =
    Reducer {state, action, reducer in
        return .none
    }
}

extension LikeDislikeList {
    enum ListType: String {
        case Like
        case Dislike
    }
}
