//
//  DashboardView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 27/12/23.
//

import SwiftUI

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var data: [ReportModel] = []
    
    func loadReports() async throws {
        self.data = try await ReportManager.instance.loadAllReports()
    }
}

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = MyReportViewModel()
    
    let columnSize: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    var body: some View {
        return AnyView(
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: columnSize) {
                        ForEach(viewModel.data, id: \.self) { each in
                            NavigationLink(destination: DetailReportView(data: each)) {
                                ReportCardView(data: each)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
                .navigationBarItems(
                    trailing: NavigationLink(
                        destination: AddReportView(),
                        label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                    )
                )
                .onAppear(perform: {
                    Task {
                        do {
                            viewModel.userId = try AuthManager.instance.getAuthUser().uid
                            try await viewModel.loadReports()
                        } catch {
                            print("Error fetching all data when view appear:", error.localizedDescription)
                        }
                    }
                })
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                
//Title
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
                .toolbarBackground(Color(hex: LB.Colors.primaryColor), for: .navigationBar)
            }
            
        )
    }
}

#Preview {
    DashboardView()
}
