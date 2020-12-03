//
//  LoginView.swift
//  SIS App
//
//  Created by Wang Yunze on 1/12/20.
//

import SwiftUI
import SwiftUIX

struct LoginView: View {
    @EnvironmentObject var userAuthManager: UserAuthManager

    @State private var email: String = ""
    @State private var password: String = ""

    @State private var showingActivityIndicator = false

    @State private var alertItem: AlertItem?

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    Text("Login/Sign up")
                        .font(.system(size: 30))

                    Spacer().frame(height: 10)

                    Text("Please use your school email")
                }
                Spacer()

                VStack {
                    HStack {
                        Text("Email: ")
                        Spacer()
                    }

                    CocoaTextField("Email", text: $email)
                        .isFirstResponder(true)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(white: 0.7), lineWidth: 2)
                        )
                }

                VStack {
                    HStack {
                        Text("Password: ")
                        Spacer()
                    }

                    SecureField("Password", text: $password)
                        .autocapitalization(.none)

                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(white: 0.7), lineWidth: 2)
                        )
                }

                Spacer()
                    .frame(height: 50)

                Button(action: {
                    print("🔥 sign in button pressed")
//                    guard email.hasSuffix(Constants.riEmailSuffix) else {
//                        alertItem = MyErrorInfo("Please use your RI email").toAlertItem()
//                        return
//                    }

                    userAuthManager.signIn(email: email, password: password, onError: onError)
                    showingActivityIndicator = true
                }) {
                    Text("Login")
                }
                .buttonStyle(GradientButtonStyle(gradient: Constants.greenGradient))

                Button(action: {
                    print("🔥 sign up button pressed")
//                    guard email.hasSuffix(Constants.riEmailSuffix) else {
//                        alertItem = MyErrorInfo("Please use your RI email").toAlertItem()
//                        return
//                    }

                    userAuthManager.signUp(
                        email: email,
                        password: password,
                        onSentEmailVerfication: {
                            print("🔥 sent email verification!")
                            showingActivityIndicator = false
                            alertItem = AlertItem(
                                title: "Please verify your account",
                                message: "A message has been sent to \(userAuthManager.userEmail). Click on the link to verify your account"
                            )
                        },
                        onError: onError
                    )
                    showingActivityIndicator = true
                }) {
                    Text("Sign up")
                }
                .buttonStyle(GradientButtonStyle(gradient: Constants.blueGradient))

                Spacer()
                Spacer() // slight hack but eh whatever
            }
            if showingActivityIndicator {
                MyActivityIndicator()
                    .frame(width: Constants.activityIndicatorSize, height: Constants.activityIndicatorSize)
            }
        }
        .padding()
        .alert(item: $alertItem, content: alertItemBuilder)
        .onDisappear {
            showingActivityIndicator = false
        }
        .onReceive(NotificationCenter.default.publisher(for: .AuthStateDidChange), perform: { _ in
            print("🔥 auth state did change")
        })
    }

    private func onError(_ error: Error) {
        print("🔥 error: \(error)")
        alertItem = MyErrorInfo(error).toAlertItem { showingActivityIndicator = false }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserAuthManager())
    }
}
