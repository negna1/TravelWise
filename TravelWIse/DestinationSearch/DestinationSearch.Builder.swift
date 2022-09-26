import ComposableArchitecture
import SwiftUI

extension DestinationSearch {
    struct Builder {
        static func build() -> some View{
            let appView = DestinationSearchView(
              store: Store(
                initialState: DestinationSearch.State(),
                reducer: DestinationSearch.reducer,
                environment: DestinationSearch.Environment(firebaseDestinations: { 
                    FirestoreManager.shared.fetchDestinations()
                })
                )
              )
            return appView
        }
    }
}
