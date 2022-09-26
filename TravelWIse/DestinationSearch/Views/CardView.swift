import SwiftUI
import ComposableArchitecture

struct CardView: View {
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LikeDislike = .none
    
    private var user: Destination
    private var onRemove: (_ user: Destination) -> Void
    private var like: (_ user: Destination) -> Void
    private var dislike: (_ user: Destination) -> Void
    private var thresholdPercentage: CGFloat = 0.5
    @State private var isSeenAlready: Bool = false
    private enum LikeDislike: Int {
        case like, dislike, none
    }
    
    init(user: Destination,
         onRemove: @escaping (_ user: Destination) -> Void,
         like: @escaping (_ user: Destination) -> Void,
         dislike: @escaping (_ user: Destination) -> Void) {
        self.user = user
        self.onRemove = onRemove
        self.dislike = dislike
        self.like = like
    }
    
    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                 ZStack(alignment: self.swipeStatus == .like ? .topLeading : .topTrailing) {
                     AsyncImage(url: URL(string: self.user.imageURL ?? ""))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                        .clipped()
                    
                    if self.swipeStatus == .like {
                        Text("LIKE")
                            .font(.headline)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.green)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green, lineWidth: 3.0)
                        ).padding(24)
                            .rotationEffect(Angle.degrees(-45))
                    } else if self.swipeStatus == .dislike {
                        Text("DISLIKE")
                            .font(.headline)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 3.0)
                        ).padding(.top, 45)
                            .rotationEffect(Angle.degrees(45))
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(self.user.title ?? "")")
                            .font(.title)
                            .bold()
                        Text("us")
                            .font(.subheadline)
                            .bold()
                        Text("\(self.user.title ?? "") Mutual Friends")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                        
                        if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage && !isSeenAlready{
                            self.swipeStatus = .like
                            self.isSeenAlready = true
                            like(user)
                        } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage &&
                                    !isSeenAlready{
                            self.swipeStatus = .dislike
                            self.isSeenAlready = true
                            dislike(user)
                        } else {
                            self.swipeStatus = .none
                        }
                        
                }.onEnded { value in
                    // determine snap distance > 0.5 aka half the width of the screen
                        if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                            self.onRemove(self.user)
                        } else {
                            self.translation = .zero
                        }
                    }
            )
        }
    }
}

