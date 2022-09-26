//
//  FirebaseLogin.swift
//  TravelWIse
//
//  Created by Nato Egnatashvili on 13.09.22.
//

import ComposableArchitecture
import FirebaseAuth
import Combine

class FirebaseHelper {
    var signInPublisher: AnyPublisher<AuthDataResult?, Never> {
        signInSubject.eraseToAnyPublisher()
        }

    private let signInSubject = PassthroughSubject<AuthDataResult?, Never>()
    
    var createPublisher: AnyPublisher<AuthDataResult?, Never> {
        createSubject.eraseToAnyPublisher()
        }

    private let createSubject = PassthroughSubject<AuthDataResult?, Never>()
    
    func FirebaseLoginEffect(email: String,
                             password: String,
                             decoder: JSONDecoder) -> Effect<AuthDataResult?, Never> {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error?.localizedDescription)
                self.signInSubject.send(nil)
            } else {
                
                authResult?.user.getIDToken(completion: { token, err in
                    print(token)
                })
                self.signInSubject.send(authResult)
                print("Log in succesful")
            }
        }
        return signInPublisher.eraseToEffect()
    }
    
    func FirebaseSignUpEffect(email: String,
                             password: String,
                             decoder: JSONDecoder) -> Effect<AuthDataResult?, Never> {
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            self.createSubject.send(result)
        }
        return createSubject.eraseToEffect()
    }
}



enum APIError: Error, Equatable {
  case downloadError
  case decodingError
  case urlNotExist
}
