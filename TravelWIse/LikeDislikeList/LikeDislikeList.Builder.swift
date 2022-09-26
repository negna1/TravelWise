import ComposableArchitecture
import SwiftUI

extension LikeDislikeList {
    struct Builder {
        static func build(type: LikeDislikeList.ListType,
                          list: [Destination]) -> some View{
            let appView = LikeDislikeListView(
              store: Store(
                initialState: LikeDislikeList.State(type: type, list: list),
                reducer: LikeDislikeList.reducer,
                environment: LikeDislikeList.Environment()
                )
              )
            return appView
        }
    }
}
