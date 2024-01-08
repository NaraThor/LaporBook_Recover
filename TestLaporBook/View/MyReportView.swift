//
//  MyReportView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 27/12/23.
//

import SwiftUI

@MainActor
final class MyReportViewModel: ObservableObject {
    @Published var data: [ReportModel] = []
    @Published var userId: String = ""
    
    func loadReports() async throws {
        self.data = try await ReportManager.instance.loadAllReports()
    }
}

struct MyReportView: View {
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
                
                //Check
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
                .padding(.top, 20)
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
    MyReportView()
}
