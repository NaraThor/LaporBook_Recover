//
//  RegisterView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 27/12/23.
//

import SwiftUI

@MainActor
final class RegisteViewModel: ObservableObject {
    @Published var nama: String = ""
    @Published var email: String = ""
    @Published var noHp: String = ""
    @Published var password: String = ""
    @Published var confirmPass: String = ""
    @Published var error: String = ""
    
    func registerUser() async throws {
        try await AuthManager.instance.createUser(email: email, password: password, fullname: nama, phone: noHp)
    }
}

struct RegisterView: View {
    @StateObject private var viewModel = RegisteViewModel()
    @State private var isAlert: Bool = false
    @EnvironmentObject private var router: Router
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .fontDesign(.none)
                    .padding(.bottom, 7)
                Text("Create your profile to start your journey")
                    .font(.subheadline)
                    .opacity(0.3)
                
                    .padding(.bottom,40)
                
                VStack(alignment: .leading, spacing:10) {
                    CustomTextFieldView(fieldBinding: $viewModel.nama, fieldName: "Nama")
                    CustomTextFieldView(fieldBinding: $viewModel.email, fieldName: "Email")
                    CustomTextFieldView(fieldBinding: $viewModel.noHp, fieldName: "No Handphone")
                    CustomTextFieldView(fieldBinding: $viewModel.password, fieldName: "Password", isPassword: true)
                    CustomTextFieldView(fieldBinding: $viewModel.confirmPass, fieldName: "Confirmation Password", isPassword: true)
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.registerUser()
                                withAnimation {
                                    self.router.currentPage = .dashboard
                                }
                            } catch {
                                print("Error creating user:", error.localizedDescription)
                                viewModel.error = error.localizedDescription
                                self.isAlert.toggle()
                            }
                        }
                    }, label: {
                        CustomButtonView(name: "Register")
                    })
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? **Login**")
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
    RegisterView()
}
