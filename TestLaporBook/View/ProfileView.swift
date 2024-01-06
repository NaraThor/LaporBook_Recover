//
//  ProfileView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 06/01/24.
//

import SwiftUI

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var role: String = ""
    
    func checkUser() async throws {
        let auth = try AuthManager.instance.getAuthUser()
        let result = try await AuthManager.instance.getFSUser(user: auth)
        
        self.email = result.email ?? ""
        self.fullName = result.fullname ?? ""
        self.phone = result.phone ?? ""
        self.role = result.role ?? ""
    }
}

struct ProfileView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    
                    Spacer()
                        .padding(.bottom,40)
                    
                    
                    Text(viewModel.fullName.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                        .padding(.top, 20)
                        .padding(.bottom, 6)
                    
                    Text(viewModel.fullName)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("admin")
                        .font(.headline)
                        .padding(.top, 6)
                        .foregroundStyle(Color(hex: LB.AppColors.primaryColor))
                    
                    
                    
                    VStack(alignment: .leading){
                        
                        DataView(Data: viewModel.email)
                        
                        DataView(Data: viewModel.phone)
                        
                    }
                    
                    .padding(.top, 20)
                    
                    Button(action: {
                        Task {
                            do {
                                try AuthManager.instance.logoutUser()
                                withAnimation {
                                    self.router.currentPage = .login
                                }
                            }
                        }
                    }, label: {
                        CustomButtonView(name: "Logout")
                            .clipShape(RoundedRectangle(cornerRadius: 1))
                    })
                    
                    .padding()
                }
                
                .onAppear(){
                    Task {
                        do {
                            try await viewModel.checkUser()
                        }
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Lapor Book")
                            .font(.system(size: 21))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(hex: LB.AppColors.primaryColor), for: .navigationBar)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
