import ComposableArchitecture
import SwiftUI

struct DestinationSearchView: View {
    
    
    let store: Store<DestinationSearch.State, DestinationSearch.Action>
    @State var presentLikes: Bool = false
    @State var presentDisLikes: Bool = false
    var body: some View {
        WithViewStore(self.store) { viewStore in
            GeometryReader { geometry in
                    LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.8509803922, green: 0.6549019608, blue: 0.7803921569, alpha: 1)), Color.init(#colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1))]), startPoint: .bottom, endPoint: .top)
                        .frame(width: geometry.size.width * 1.5, height: geometry.size.height)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .offset(x: -geometry.size.width / 4, y: -geometry.size.height / 2)
                        .ignoresSafeArea()
                    ScrollView {
                        DateView()
                        HStack {
                            NavigationLink(isActive: $presentDisLikes) {
                                LikeDislikeList.Builder.build(type: .Dislike,
                                                              list: viewStore.state.unlikes)
                            } label: {
                                Button("Dislikes") {
                                    self.presentDisLikes = true
                                }
                            }
                            Spacer()
                            NavigationLink(isActive: $presentLikes) {
                                LikeDislikeList.Builder.build(type: .Like,
                                                              list: viewStore.state.likes)
                            } label: {
                                Button("Likes") {
                                    self.presentLikes = true
                                }
                            }
                            
                        }
                        SalesFooterView(viewStore: viewStore, geometry: geometry)
                        Spacer()
                    }
            }.ignoresSafeArea()
            .padding()
            .navigationBarHidden(true)
                .onAppear {
                    viewStore.send(.viewAppear)
                }
        }
        
        
    }
    
    struct SalesFooterView: View {
        private func getCardWidth(_ geometry: GeometryProxy, cnt: Int) -> CGFloat {
            let offset: CGFloat = CGFloat(cnt) * 10
            return geometry.size.width - offset
        }
        
        /// Return the CardViews frame offset for the given offset in the array
        /// - Parameters:
        ///   - geometry: The geometry proxy of the parent
        ///   - id: The ID of the current user
        private func getCardOffset(_ geometry: GeometryProxy, cnt: Int) -> CGFloat {
            return  CGFloat(cnt) * 10
        }
        
        var viewStore: ViewStore<DestinationSearch.State, DestinationSearch.Action>
        let geometry: GeometryProxy
        @ViewBuilder
        var body: some View {
            if let dest = viewStore.state.destinations {
                
                    ZStack {
                        ForEach(dest, id: \.self) { d in
                            AsyncImage(url: URL(string: d.imageURL ?? "")) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(maxWidth: 300, maxHeight: 300)
                                            case .success(let image):
                                                image.resizable()
                                                    .cornerRadius(30)
                                                     .frame(maxWidth: 300, maxHeight: 300)
                                            case .failure:
                                                Image(systemName: "photo")
                                            @unknown default:
                                                // Since the AsyncImagePhase enum isn't frozen,
                                                // we need to add this currently unused fallback
                                                // to handle any new cases that might be added
                                                // in the future:
                                                EmptyView()
                                            }
                                        }
                        VStack{
                        Text(d.title ?? "")
                                .font(.headline)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white))
                            Spacer()
                        HStack {
                        Button {
                            viewStore.send(.didLike(d))
                            viewStore.send(.removeDest(d.id))
                        } label: {
                            Text("Like")
                                .font(.title)
                                .foregroundColor(.green)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white))
                        }
                            Spacer()
                        Button {
                            viewStore.send(.didUnlike(d))
                            viewStore.send(.removeDest(d.id))
                        } label: {
                            Text("Dislike")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white))
                        }}.frame(width: 300,  alignment: .center)
                            
                        }
                    }
//                    Group {
//                        // Range Operator
//
//                        if (dest.map { $0.id }.max() ?? 0 - 3)...(dest.map { $0.id }.max() ?? 0) ~= user.id {
//
//                            CardView(user: user) { removedUser in
//                                viewStore.send(.removeDest(removedUser.id))
//                            } like: { user in
//                                viewStore.send(.didLike(user))
//                            } dislike: { user in
//                                viewStore.send(.didUnlike(user))
//                            }.animation(.spring())
//                                .frame(width: getCardWidth(geometry, cnt: dest.count - 1 - user.id), height: 400)
//                                .offset(x: 0, y: getCardOffset(geometry, cnt: dest.count - 1 - user.id))
//                        }
//                    }
                }
            }else {
                Text("No Destination here")
                    .font(.title)
                    .foregroundColor(.purple)
                    .frame(alignment: .center)
            }
            
        }
    }
    
    struct DateView: View {
        var body: some View {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(Date().customDumpDescription)
                            .font(.title)
                            .bold()
                        Text("Today")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }.padding()
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        
    }
}

