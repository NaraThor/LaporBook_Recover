//
//  ViewController.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 27/12/23.
//

import SwiftUI

enum Page {
    case launchScreen, dashboard, login
}

class Router: ObservableObject {
    @Published var currentPage: Page = .launchScreen
}

struct ViewController: View {
    @EnvironmentObject var router: Router
    @State private var showLoginView: Bool = false
    
    var body: some View {
        switch router.currentPage {
        case .launchScreen:
            VStack {
                Image(systemName: "book.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: LB.Colors.primaryColor))
                Spacer()
                    .frame(height: 20)
                Text("Lapor Book")
                    .font(.custom("Poppins-Bold", size: 30))
                    .foregroundColor(Color(hex: LB.Colors.primaryColor))
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                let auth = try? AuthManager.instance.getAuthUser()
                                if (auth != nil) {
                                    self.router.currentPage = .dashboard
                                } else {
                                    self.router.currentPage = .login
                                }
                            }
                        }
                    })
            }
            .padding()
        case .dashboard:
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "square.stack")
                    }
                MyReportView()
                    .tabItem {
                        Label("My Report", systemImage: "book")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .transition(.move(edge: .trailing))
        case .login:
            LoginView()
                .transition(.move(edge: .leading))
        }
    }
}

#Preview {
    ViewController()
        .environmentObject(Router())
}
