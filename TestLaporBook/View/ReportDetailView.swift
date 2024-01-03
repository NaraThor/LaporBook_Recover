//
//  ReportDetailView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 03/01/24.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

@MainActor
final class ReportDetailViewModel: ObservableObject {
  @Published var userRole: String = ""
  func changeStatus(to newStatus: String, reportId: String) async throws {
    do {
      try await ReportManager.instance.changeStatus(to: newStatus, id: reportId)
    } catch {
      print("Error change status:", error.localizedDescription)
    }
  }
}

struct ReportDetailView: View {
  @Environment(\.presentationMode) var presentation
  @State private var changeStatusDialog: Bool = false
  @StateObject private var viewModel = ReportDetailViewModel()
  
  var data: ReportModel?
  
  var body: some View {
    List {
      WebImage(url: URL(string: data?.imgPath ?? ""))
        .resizable()
        .placeholder(content: {
          ProgressView()
            .font(.title)
            .frame(height: UIScreen.main.bounds.height * 0.3)
            .frame(maxWidth: .infinity)
        })
        .onFailure(perform: { _ in
          VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
              .font(.largeTitle)
            Text("Gagal mengunduh")
          }
        })
        .scaledToFit()
        .frame(height: UIScreen.main.bounds.height * 0.3)
        .frame(maxWidth: .infinity)
        .frame(alignment: .center)
      ReportDetailLabelView(data: data?.fullname ?? "", title: "Nama Pelapor", imageSystemName: "person.fill")
      ReportDetailLabelView(data: String(date: data?.date ?? Date(), format: "dd MMMM yyy"), title: "Tanggal Laporan", imageSystemName: "calendar")
      ReportDetailLabelView(data: data?.status ?? "", title: "Status Laporan", imageSystemName: "doc.fill")
      ReportDetailLabelView(data: data?.instance ?? "", title: "Instansi", imageSystemName: "building.fill")
      ReportDetailLabelView(data: data?.desc ?? "", title: "Deskripsi Laporan", imageSystemName: "quote.opening")
        HStack {
          Image(systemName: "map.fill")
            .foregroundStyle(.accent)
            .font(.title2)
            .frame(width: 20)
          Text("Lokasi Laporan")
        }
      
      if viewModel.userRole == "Admin" {
        Section {
          Button("Ubah Status...") {
            changeStatusDialog.toggle()
          }
        }
      }
    }
    .confirmationDialog("", isPresented: $changeStatusDialog) {
      Button("Posted") {
        Task {
          do {
            try await viewModel.changeStatus(to: "Posted", reportId: data?.id ?? "")
            presentation.wrappedValue.dismiss()
          }
        }
      }
      Button("Process") {
        Task {
          do {
            try await viewModel.changeStatus(to: "Process", reportId: data?.id ?? "")
            presentation.wrappedValue.dismiss()
          }
        }
      }
      Button("Done") {
        Task {
          do {
            try await viewModel.changeStatus(to: "Done", reportId: data?.id ?? "")
            presentation.wrappedValue.dismiss()
          }
        }
      }
    } message: {
      Text("Ubah status laporan...")
    }
                        
    .onAppear(perform: {
      Task {
        do {
          let auth = try AuthManager.instance.getAuthUser()
          let result = try await AuthManager.instance.getFSUser(user: auth)
          viewModel.userRole = result.role ?? ""
        } catch {
          print("Error getting user role:", error.localizedDescription)
        }
      }
    })
    .navigationTitle("Detail Laporan")
  }
}

#Preview {
  NavigationStack {
    ReportDetailView(data: ReportModel(date: Date(), id: "123", desc: "Dummy Description", imgFilename: "", imgPath: "", instance: "Suatu Instansi", title: "", userId: "", fullname: "SpongeBob SquarePants", status: "Done"))
  }
}


