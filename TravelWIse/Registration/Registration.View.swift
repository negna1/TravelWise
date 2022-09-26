import ComposableArchitecture
import SwiftUI

struct RegistrationView: View {
    let store: Store<Registration.State, Registration.Action>
    @State var emailText: String = ""
    @State var password: String = ""
    @State var username: String = ""
    
    @State var emailTextL: String = ""
    @State var passwordL: String = ""
    @State var needNav: Bool = false
    var body: some View {
        WithViewStore(self.store) { viewStore in
            
            NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                NavigationLink(isActive: .constant(viewStore.state.userId != nil ),
                               destination: DestinationSearch.Builder.build) {
                    EmptyView()
                }
                VStack(spacing: 40) {
                    HStack(spacing: 40) {
                        Button {
                            viewStore.send(.didChangeState(state: .login))
                        } label: {
                            Text("Log in")
                                .foregroundColor(viewStore.state.activeState == .login ?
                                                 Color.purple : Color.gray )
                                
                        }
                        
                        Button {
                            viewStore.send(.didChangeState(state: .signUp))
                        } label: {
                            Text("Sign Up")
                                .foregroundColor(viewStore.state.activeState == .signUp ?
                                                 Color.purple : Color.gray )
                                
                        }
                    }
                    switch viewStore.state.activeState {
                    case .login:
                        LoginView(action: {
                            viewStore.send(.didTapLogin(email: emailTextL, password: passwordL))
                        }, emailText: $emailTextL, password: $passwordL)
                    case .signUp:
                        SignUpView(action: {
                            viewStore.send(.didTapSignUp(username: username, email: emailText, password: password))
                        }, username: $username, emailText: $emailText, password: $password)
                    }
                }
                                                                   
            }
            }.navigationBarHidden(true)
        }
    }
    
    struct LoginView: View {
        var action: () -> ()
        @Binding var emailText: String
        @Binding var password: String
        @State var isHidden: Bool = true
        var body: some View {
            VStack {
                CustomTextField(txt: $emailText,
                                label: "Enter Email..",
                                iconName: "ic_email")
                
                HStack(alignment: .center) {
                    Image("ic_passcode")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding([.leading], 10)
                    Spacer()
                    if isHidden {
                        SecureField(
                            "Enter Password",
                           text: $password
                        )
                        .padding([.trailing], 10)
                    }else {
                        TextField(
                            "Enter Password",
                           text: $password
                        )
                        .padding([.trailing], 10)
                    }
                   
                    Button {
                        isHidden = !isHidden
                    } label: {
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .tint(.gray)
                    }.padding([.trailing], 10)

                }
                .frame(height: 50, alignment: .center)
                .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                .padding([.leading, .trailing], 16)
                .cornerRadius(10)
                
                Button {
                    action()
                } label: {
                    Text("Log In")
                        .foregroundColor(.white)
                }
                    .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundColor(Color.purple)
                        .frame(width: 200, height: 50, alignment: .center))
                    .padding(.top, 16)
            }
        }
    }
    
    struct SignUpView: View {
        var action: () -> ()
        @Binding var username: String
        @Binding var emailText: String
        @Binding var password: String
        @State var isHidden: Bool = true
        var body: some View {
            VStack {
                CustomTextField(txt: $username,
                                label: "Enter Username..",
                                iconName: "ic_username")
                CustomTextField(txt: $emailText,
                                label: "Enter Email..",
                                iconName: "ic_email")
                
                
                HStack(alignment: .center) {
                    Image("ic_passcode")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding([.leading], 10)
                    Spacer()
                    if isHidden {
                        SecureField(
                            "Enter Password",
                           text: $password
                        )
                        .padding([.trailing], 10)
                    }else {
                        TextField(
                            "Enter Password",
                           text: $password
                        )
                        .padding([.trailing], 10)
                    }
                   
                    Button {
                        isHidden = !isHidden
                    } label: {
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .tint(.gray)
                    }.padding([.trailing], 10)

                }
                .frame(height: 50, alignment: .center)
                .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                .padding([.leading, .trailing], 16)
                .cornerRadius(10)
                
                Button {
                    action()
                } label: {
                    Text("Sign Up")
                        .foregroundColor(.white)
                }
                    .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundColor(Color.purple)
                        .frame(width: 200, height: 50, alignment: .center))
                    .padding(.top, 16)
            }
        }
    }
    
    struct CustomTextField: View {
        @Binding var txt: String
        var label: String
        var iconName: String
        var body: some View {
            VStack {
                HStack(alignment: .center) {
                    Image(iconName)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding([.leading], 10)
                    Spacer()
                    TextField(
                        label,
                       text: $txt
                    )
                    .padding([.trailing], 10)
                }
                .frame(height: 50, alignment: .center)
                .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                .padding([.leading, .trailing], 16)
                .cornerRadius(10)
            }
        }
    }
}

//struct LogPreviews: PreviewProvider {
//    @State static var emailText: String = ""
//    @State static var password: String = ""
//    static var previews: some View {
//        RegistrationView.LoginView(action: {}, emailText: $emailText, password: $password)
//            .previewLayout(PreviewLayout.sizeThatFits)
//            .padding()
//            .previewDisplayName("Default preview")
//    }
//}
