//
//  LoginView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 27/12/23.
//

import SwiftUI

@MainActor final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String = ":"
    
    func signIn(email: String, password: String) async throws {
        try await AuthManager.instance.signInUser(email: email, password: password)
    }
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isAlert: Bool = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .fontDesign(.none)
                    .padding(.bottom, 7)
                Text("Login to your existing account")
                    .font(.subheadline)
                    .opacity(0.3)
                    .padding(.bottom,40)
                
                
                VStack(alignment: .leading, spacing: 10) {
                    CustomTextFieldView(fieldBinding: $viewModel.email, fieldName: "Email")
                    CustomTextFieldView(fieldBinding: $viewModel.password, fieldName: "Password", isPassword: true)
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signIn(email: viewModel.email, password: viewModel.password)
                                withAnimation {
                                    router.currentPage = .dashboard
                                }
                            } catch {
                                print("Error login:", error.localizedDescription)
                                viewModel.error = error.localizedDescription
                                isAlert.toggle()
                            }
                        }
                    }, label: {
                        CustomButtonView(name: "Login")
                        
                    })
                    NavigationLink(destination: RegisterView()) {
                        Text("Don't have an account? **Register**")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            })
            .alert(isPresented: $isAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.error), dismissButton: .default(Text("OK")))
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    LoginView()
}
