import Firebase
import FirebaseFirestore
import ComposableArchitecture
import Combine

class FirestoreManager: ObservableObject {
    static let shared: FirestoreManager = .init()
    
    var createPublisher: AnyPublisher<Destinations?, Never> {
        createSubject.eraseToAnyPublisher()
        }

    private let createSubject = PassthroughSubject<Destinations?, Never>()
    
    func fetchDestinations() -> Effect<Destinations?, Never> {
        
        let db = Firestore.firestore()
        db.collection("Destinations").getDocuments { snapshot, error in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            let v = snapshot.map { snap in
                snap.documents.map { s -> Destinations in
                    Destinations.init(params: s.data())
                }
            }
            
            return  self.createSubject.send(v?.first)
        }
        return createPublisher.eraseToEffect()
    }
    
}

