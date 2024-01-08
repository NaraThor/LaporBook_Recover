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
final class ReportDetailView: ObservableObject {
    @Published var user: FSUser = FSUser(uid: "", email: "", fullname: "", phone: "", role: "")
    @Published var isLiked: Bool = false
    
    @Published var allLikes: [LikeModel] = []
    @Published var like: LikeModel? = LikeModel(date: Date(), author: "", id: "")
    
    func changeStatus(to newStatus: String, reportId: String) async throws {
        do {
            try await ReportManager.instance.changeStatus(to: newStatus, id: reportId)
        } catch {
            print("Error change status:", error.localizedDescription)
        }
    }
    
    func addLike(reportId: String) async throws {
        let auth = try AuthManager.instance.getAuthUser()
        let result = try await AuthManager.instance.getFSUser(user: auth)
        try await ReportManager.instance.addLike(reportId: reportId, author: result.fullname ?? "")
    }
    
    func delLike(reportId: String, likeId: String) async throws {
        try await ReportManager.instance.delLike(reportId: reportId, likeId: likeId)
    }
}

struct DetailReportView: View {
    @Environment(\.presentationMode) var presentation
    @State private var changeStatusDialog: Bool = false
    @StateObject private var viewModel = ReportDetailView()
    
    var data: ReportModel?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 10) {
                    Text(data?.title ?? "")
                        .font(.system(size: 30))
                        .padding(.top, 20)
                    WebImage(url: URL(string: data?.imgPath ?? ""))
                        .resizable()
                        .placeholder(content: {
                            ProgressView()
                                .font(.title)
                                .frame(height: UIScreen.main.bounds.height * 0.3)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                        })
                        .onFailure(perform: { _ in
                            VStack(spacing: 16) {
                                Image(systemName: "wifi.slash")
                                    .font(.largeTitle)
                                Text("Gagal mengunduh")
                            }
                        })
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(height: UIScreen.main.bounds.height * 0.2)
                        .frame(maxWidth: .infinity)
                        .frame(alignment: .center)
                        .cornerRadius(10)
                        .padding(.top, 20)
                    
                    
                    ///////Testo
                    
                    HStack{
                        VStack{
                            Text(data?.status ?? "")
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                                .padding()
                            
                        }
                        .frame(width: 150, height: 30)
                        .background(getBackgroundColor(for: data?.status))
                        .cornerRadius(10)
                        
                        Spacer()
                        
                        VStack{
                            Text(data?.instance ?? "")
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .cornerRadius(10)
                        .frame(width: 150, height: 30)
                        
                        Spacer()
                        
                        ///like
                        VStack{
                            HStack{
                                HStack(alignment: .lastTextBaseline){
                                    Button(action: {
                                        if viewModel.isLiked {
                                            Task {
                                                do {
                                                    try await viewModel.delLike(reportId: data?.id ?? "", likeId: viewModel.like?.id ?? "")
                                                    viewModel.allLikes = try await ReportManager.instance.loadAllLikes(reportId: data?.id ?? "")
                                                    viewModel.like = ReportManager.instance.filterModel(by: data?.fullname ?? "", in: viewModel.allLikes)
                                                    viewModel.isLiked = false
                                                }
                                            }
                                        } else {
                                            Task {
                                                do {
                                                    try await viewModel.addLike(reportId: data?.id ?? "")
                                                    viewModel.allLikes = try await ReportManager.instance.loadAllLikes(reportId: data?.id ?? "")
                                                    viewModel.like = ReportManager.instance.filterModel(by: data?.fullname ?? "", in: viewModel.allLikes)
                                                    viewModel.isLiked = true
                                                }
                                            }
                                        }
                                    }, label: {
                                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")                                .foregroundStyle(.white)
                                    })
                                    VStack(alignment:.trailing){
                                        Text("\(viewModel.allLikes.count)")
                                            .font(.system(size: 14))
                                            .foregroundStyle(.white)
                                            .padding(.leading,-5)
                                    }
                                    
                                }
                            }
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .cornerRadius(10)
                        .frame(width: 55, height: 30)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    
                    //Mark
                    //                    HStack{
                    //                        HStack(alignment: .lastTextBaseline){
                    //                            Button(action: {
                    //                                if viewModel.isLiked {
                    //                                    Task {
                    //                                        do {
                    //                                            try await viewModel.delLike(reportId: data?.id ?? "", likeId: viewModel.like?.id ?? "")
                    //                                            viewModel.allLikes = try await ReportManager.instance.loadAllLikes(reportId: data?.id ?? "")
                    //                                            viewModel.like = ReportManager.instance.filterModel(by: data?.fullname ?? "", in: viewModel.allLikes)
                    //                                            viewModel.isLiked = false
                    //                                        }
                    //                                    }
                    //                                } else {
                    //                                    Task {
                    //                                        do {
                    //                                            try await viewModel.addLike(reportId: data?.id ?? "")
                    //                                            viewModel.allLikes = try await ReportManager.instance.loadAllLikes(reportId: data?.id ?? "")
                    //                                            viewModel.like = ReportManager.instance.filterModel(by: data?.fullname ?? "", in: viewModel.allLikes)
                    //                                            viewModel.isLiked = true
                    //                                        }
                    //                                    }
                    //                                }
                    //                            }, label: {
                    //                                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")                                .foregroundStyle(.white)
                    //                            })
                    //                            VStack(alignment:.trailing){
                    //                                Text("\(viewModel.allLikes.count)")
                    //                                    .font(.system(size: 14))
                    //                                    .foregroundStyle(.white)
                    //                                    .padding(.leading,-5)
                    //                            }
                    //
                    //                        }
                    //                    }
                    //                    .frame(height: 30)
                    //                    .frame(maxWidth: .infinity)
                    //                    .background(.accent)
                    //                    .cornerRadius(10)
                    
                    HStack{
                        Image(systemName: "person.fill")
                        VStack{
                            Text("Nama Pelapor")
                                .font(.system(size: 14))
                            Text(data?.fullname ?? "")
                                .font(.system(size: 12))
                        }
                    }
                    .padding(.top, 20)
                    HStack{
                        HStack{
                            Image(systemName: "calendar")
                            VStack(alignment: .leading){
                                Text("Tanggal Lengkap")
                                    .font(.system(size: 14))
                                Text(String(date: data?.date ?? Date(), format: "DD-MM-YY"))
                                    .font(.system(size: 12))
                            }
                        }
                        .padding(.trailing,20)
                        
                        VStack{
                            Image(systemName: "mappin")
                            VStack{
                                Button("Semarang") {
                                    UIApplication.shared.open(URL(string: "comgooglemaps://?q=\(data?.latitude ?? 0),\(data?.longitude ?? 0)")!)
                                }
                                .font(.system(size: 12))
                                .foregroundStyle(.black)
                            }
                        }
                    }
                    .padding(.top, 20)
                    
                    
                    
                    ///Deskripsilengkap
                    Text("Deskripsi Lengkap")
                        .font(.system( size: 20))
                        .padding(.top, 20)
                    
                    Text(data?.desc ?? "")
                        .font(.system(size: 12))
                        .padding(.horizontal)
                    
                    Button(action: {
                        if viewModel.user.role == "admin" {
                            changeStatusDialog.toggle()
                        }
                        
                    }, label: {
                        CustomButtonChangeView(name: "Ubah Status")
                    })
                    
                }
                .padding()
               
                
            })
        }
        
        ///ConfirmationDialog
        .confirmationDialog("", isPresented: $changeStatusDialog) {
            Button("Posted") {
                Task {
                    do {
                        try await viewModel.changeStatus(to: "Posted", reportId: data?.id ?? "")
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            Button("Proses") {
                Task {
                    do {
                        try await viewModel.changeStatus(to: "Proses", reportId: data?.id ?? "")
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
            Text("Ubah status laporan")
        }
        
        
        ///Apeareance
        .onAppear(perform: {
            Task {
                do {
                    let auth = try AuthManager.instance.getAuthUser()
                    viewModel.user = try await AuthManager.instance.getFSUser(user: auth)
                    viewModel.allLikes = try await ReportManager.instance.loadAllLikes(reportId: data?.id ?? "")
                    viewModel.isLiked = ReportManager.instance.checkLike(array: viewModel.allLikes, query: viewModel.user.fullname ?? "")
                    viewModel.like = ReportManager.instance.filterModel(by: viewModel.user.fullname ?? "", in: viewModel.allLikes)
                } catch {
                    print("Error getting user role:", error.localizedDescription)
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Detail Laporan")
                        .font(.system(size: 21))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            
            ///Tollbar
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentation.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: LB.Colors.primaryColor), for: .navigationBar)
    }
    func getBackgroundColor(for status: String?) -> Color {
        switch status {
        case "Posted":
            return Color(hex: LB.Colors.dangerColor)
        case "Proses":
            return Color(hex: LB.Colors.warningColor)
        case "Done":
            return Color(hex: LB.Colors.successColor)
        default:
            return Color.gray
        }
    }
}

#Preview {
    NavigationStack {
        DetailReportView(data: ReportModel(date: Date(), id: "12345", desc: "Deskripsi", imgFilename: "", imgPath: "", instance: "Suatu Instansi", title: "", userId: "", fullname: "Nama Lelapor", status: "Done", latitude: 0, longitude: 0))
    }
}
