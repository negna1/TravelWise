import ComposableArchitecture
import SwiftUI

extension Registration {
    struct Builder {
        static func build() -> some View{
            let appView = RegistrationView(
              store: Store(
                initialState: Registration.State(),
                reducer: Registration.reducer,
                environment: Registration.Environment(firebaseLogin: { email, password in
                    FirebaseHelper().FirebaseLoginEffect(email: email, password: password, decoder: JSONDecoder())
                }, firebaseUserCreate:  { email, password in
                    FirebaseHelper().FirebaseSignUpEffect(email: email, password: password, decoder: JSONDecoder())
                })
                )
              )
            return appView
        }
    }
}
