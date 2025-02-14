//
//  SignInView.swift
//  TakeHomeExercise
//
//  Created by Alexey L on 1/28/24.
//

import SwiftUI


// Shows minimum user details on a navigation link.
struct SignInViewNavLink: View {
    @EnvironmentObject var userContext: UserContext
    var body: some View {
        HStack {
            Image(systemName: userContext.userImageText).resizable().scaledToFit()
                .padding()
                .foregroundColor(userContext.userName != nil ? .green : .gray)
            Text(userContext.displayName)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
} // LOGIN VIEW NAV LINK


// A simple name-value pair view.
struct InfoFieldView: View {
    let name: String
    let value: String?
    let infoWidth: Double
    
    var body: some View {
        let labelWidth = infoWidth * 0.3
        HStack {
            Text(name)
                .padding(.horizontal)
                .frame(width: labelWidth, alignment: .leading)
            Text(value ?? "null")
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 10).fill(.tertiary.opacity(0.2))
                }
        }
    }
} // INFO FIELD VIEW



// Detailed view of user info, including controls to sign in.
struct SignInView: View {
    @EnvironmentObject var userContext: UserContext
    
    @State var userName = "takehome@aircover.ai"
    @State var password = "contact me at aubyte@gmail.com"
    
    var body: some View {
        GeometryReader { geo in
            
            let imageSize = geo.size.width * Resources.Login.USER_IMAGE_SIZE
            let textFieldWidth = geo.size.width * Resources.Login.TEXT_FIELD_WIDTH
            let infoWidth = geo.size.width
            let labelWidth = infoWidth * 0.2
            
            ScrollView(.vertical) {
                VStack {
                    
                    // 1. User image, name, password, and sign in button.
                    
                    HStack {
                        Image(systemName: userContext.userImageText).renderingMode(.original).resizable().scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                            .foregroundColor(.gray)
                            .animation(.easeInOut, value: userContext.userImageText)
                        
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("User:")
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .frame(width: labelWidth, alignment: .trailing)
                                    TextField("user", text: $userName)
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .frame(width: textFieldWidth, alignment: .trailing)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10).fill(.tertiary.opacity(0.5))
                                        }
                                }
                                HStack {
                                    Text("Password:")
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .frame(width: labelWidth, alignment: .trailing)
                                    TextField("password", text: $password)
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .frame(width: textFieldWidth, alignment: .trailing)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10).fill(.tertiary.opacity(0.5))
                                        }
                                }
                            } // VSTACK
                            .opacity(userContext.authenticationInProgress ? 0.25 : 1)
                            .disabled(userContext.authenticationInProgress)
                            
                            HStack {
                                HStack {
                                    Group {
                                        if userContext.authenticationInProgress {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                        } else if let errorMessage = userContext.authErrorMessage {
                                            Text(errorMessage)
                                                .foregroundColor(.red)
                                        } else if userContext.userName != nil {
                                            Image(systemName: "checkmark.icloud").resizable().scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .transition(.opacity.combined(with: .scale))
                                }
                                .padding()
                                .frame(width: labelWidth, alignment: .trailing)
                                
                                Button {
                                    if userContext.authenticationInProgress {
                                        userContext.cancelAuthentication()
                                    } else {
                                        userContext.initiateAuthentication(userName: userName, password: password)
//                                        userContext.initiateAuthenticationTest(userName: userName, password: password)
                                    }
                                } label: {
                                    Text(userContext.authenticationInProgress ? "Cancel" : "Authenticate")
                                        .padding()
                                        .frame(width: textFieldWidth)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10).fill(.tertiary)
                                        }
                                        .frame(alignment: .trailing)
                                }
                            }
                        } // VSTACK
                    } // HSTACK
                    .padding()

                    

                    // 2. Authentication response info.
                    
                    if let lr = userContext.loginResponse {
                        VStack(alignment: .leading) {
                            VStack {
                                InfoFieldView(name: "Account verified:", value: lr.data[0].account_verified.description, infoWidth: infoWidth)
                                InfoFieldView(name: "Customer org list:", value: lr.data[0].customer_org_list[0], infoWidth: infoWidth)
                                InfoFieldView(name: "Google linked:", value: lr.data[0].google_linked.description, infoWidth: infoWidth)
                                InfoFieldView(name: "Google scopes need update:", value: lr.data[0].google_scopes_need_update.description, infoWidth: infoWidth)
                            }
                            VStack {
                                InfoFieldView(name: "Zoom linked:", value: lr.data[0].zoom_linked.description, infoWidth: infoWidth)
                                InfoFieldView(name: "SFDC linked:", value: lr.data[0].sfdc_linked.description, infoWidth: infoWidth)
                                InfoFieldView(name: "Highspot linked:", value: lr.data[0].highspot_linked.description, infoWidth: infoWidth)
                                InfoFieldView(name: "MS linked:", value: lr.data[0].ms_linked.description, infoWidth: infoWidth)
                            }
                            VStack {
                                InfoFieldView(name: "Access token:", value: lr.data[0].access_token, infoWidth: infoWidth)
                                InfoFieldView(name: "Refresh token:", value: lr.data[0].refresh_token, infoWidth: infoWidth)
                                InfoFieldView(name: "Magic token:", value: lr.data[0].magic_token, infoWidth: infoWidth)
                                //                            InfoFieldView(name: ":", value: userContext.loginResponse?.data[0]., infoWidth: infoWidth)
                            }
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10).fill(.tertiary.opacity(0.1))
                        }
                        .padding()
                        .frame(width: infoWidth)
                        .transition(.opacity.combined(with: .scale))
                    } // IF

                } // VSTACK
                .padding(.top)
                .animation(.easeInOut(duration: 0.2), value: userContext.authenticationInProgress)
            } // SCROLL VIEW
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        } // GEO
    }
} // SIGNIN VIEW



//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
