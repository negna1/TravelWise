import ComposableArchitecture
import FirebaseAuth

enum Registration {
    struct State: Equatable {
        var activeState: RegistrationButtonState = .login
        var userId: String? = nil
    }
    
    enum Action: Equatable {
        case didTapLogin(email: String, password: String)
        case didTapSignUp(username: String, email: String, password: String)
        case didChangeState(state: RegistrationButtonState)
        case fetchSignIn(Result<AuthDataResult?, Never>)
        case fetchSignUp(Result<AuthDataResult?, Never>)
    }
    
    struct Environment {
        var firebaseLogin: (_ email: String, _ password: String) -> Effect<AuthDataResult?, Never>
        var firebaseUserCreate: (_ email: String, _ password: String) -> Effect<AuthDataResult?, Never>
        var mainQueue: () -> AnySchedulerOf<DispatchQueue> = {.main}
    }
    
    static let reducer: Reducer<State, Action, Environment> =
    Reducer {state, action, environment in
        switch action {
        case .didTapLogin(let email, let password):
            return environment.firebaseLogin(email, password)
                  .receive(on: environment.mainQueue())
                  .catchToEffect()
                  .map(Action.fetchSignIn)
        case .fetchSignIn(let result):
             let id = result.map({ res in
                 state.userId = res?.user.uid
            })
        case .fetchSignUp(let result):
            print(result)
        case .didTapSignUp(let username ,let email, let password):
            return environment.firebaseUserCreate(email, password)
                  .receive(on: environment.mainQueue())
                  .catchToEffect()
                  .map(Action.fetchSignUp)
        case .didChangeState(let regstate):
            state.activeState = regstate
        }
        return .none
    }
}

extension Registration {
    enum RegistrationButtonState {
        case login
        case signUp
    }
}
