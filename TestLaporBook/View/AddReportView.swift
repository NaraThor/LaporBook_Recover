//
//  AddReportView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 27/12/23.
//

import SwiftUI

@MainActor
final class AddReportViewModel: ObservableObject {
    @Published var judul: String = ""
    @Published var deskripsi: String = ""
    @Published var selected: String = "Testo"
    @Published var image: Image? = nil
    @Published var coordinatPoint: (Double, Double) = (0, 0)
    
    func create(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        Task {
            do {
                let render = ImageRenderer(content: image!)
                let result = try await StorageManager.instance.saveImage(data: (render.uiImage?.jpegData(compressionQuality: 1))!)
                try await ReportManager.instance.createReport(title: self.judul, instance: self.selected, desc: self.deskripsi, path: result.path, filename: result.filename, lat: self.coordinatPoint.0, long: self.coordinatPoint.1)
                success()
                success()
            } catch {
                failure(error)
            }
        }
    }
}

struct AddReportView: View {
    @Environment(\.presentationMode) var presentation
    @StateObject private var viewModel = AddReportViewModel()
    @StateObject var location = LocationManager()
    @State private var imageSheetView: Bool = false
    @State private var shouldPresentImagePicker: Bool = false
    @State private var shouldPresentCamera: Bool = false
    
    @FocusState var descFocus: Bool
    
    var instances: [String] = ["Pembangunan", "Jalanan", "Pendidikan"]
    var body: some View {
        
    // Judul Laporan
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .center) {
                    Spacer()
//                    Text("Judul Laporan")
//                        .foregroundColor(.black)
//                        .padding()
//                        .multilineTextAlignment(.center)
//                    
//                        .frame(height: 10)
                    CustomTextFieldView(fieldBinding: $viewModel.judul, fieldName: "Judul Laporan")
                        .multilineTextAlignment(.leading)
                        .padding(.bottom,15)
                        .padding(.top,20)
                    
                    
  //Images
                    VStack(alignment: .leading){
                        Text("Foto Pendukung")
                            .font(.custom("Poppins-Bold", size: 14))
                        
                        if let userImage = viewModel.image {
                            userImage
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(.gray, lineWidth: 2)
                                        .opacity(descFocus ? 1 : 0.5)
                                )
                                .cornerRadius(14)
                                .onTapGesture {
                                    self.imageSheetView.toggle()
                                }
                                .sheet(isPresented: $shouldPresentImagePicker) {
                                    SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: $viewModel.image, isPresented: self.$shouldPresentImagePicker)
                                }
                                .actionSheet(isPresented: $imageSheetView) { () -> ActionSheet in
                                    ActionSheet(title: Text("Pilih Foto"), message: Text("Pilih satu foto sebagai dokumentasi laporan"), buttons: [ActionSheet.Button.default(Text("Kamera"), action: {
                                        self.shouldPresentImagePicker = true
                                        self.shouldPresentCamera = true
                                    }), ActionSheet.Button.default(Text("Pilih dari Galeri"), action: {
                                        self.shouldPresentImagePicker = true
                                        self.shouldPresentCamera = false
                                    }), ActionSheet.Button.cancel()])
                                }
                        } else {
                            VStack(spacing: 16) {
                                HStack{
                                    Text("Pilih foto")
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 25)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.gray, lineWidth: 2)
                                    .opacity(descFocus ? 1 : 0.5)
                            )
                            .onTapGesture {
                                self.imageSheetView.toggle()
                            }
                            .sheet(isPresented: $shouldPresentImagePicker) {
                                SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: $viewModel.image, isPresented: self.$shouldPresentImagePicker)
                            }
                            .actionSheet(isPresented: $imageSheetView) { () -> ActionSheet in
                                ActionSheet(title: Text("Pilih Foto"), message: Text("Pilih satu foto sebagai dokumentasi laporan"), buttons: [ActionSheet.Button.default(Text("Kamera"), action: {
                                    self.shouldPresentImagePicker = true
                                    self.shouldPresentCamera = true
                                }), ActionSheet.Button.default(Text("Pilih dari Galeri"), action: {
                                    self.shouldPresentImagePicker = true
                                    self.shouldPresentCamera = false
                                }), ActionSheet.Button.cancel()])
                            }
                        }
                    }
                    .padding(.bottom,15)
                    
                    
//Instansi
                    VStack(alignment: .leading) {
                        Text("Instansi")
                            .font(.custom("Poppins-Bold", size: 14))
                        Picker("Selected Instance", selection: $viewModel.selected) {
                            ForEach(instances, id: \.self) { each in
                                Text(each)
                                    .font(.custom("Poppins-Regular", size: 20))
                            }
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .pickerStyle(.wheel)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(.gray, lineWidth: 2)
                                .opacity(descFocus ? 1 : 0.5)
                        )
                    }
                    
                    .padding(.bottom,15)
                    
  //Deskripsi lengkap
                    VStack(alignment: .leading) {
                        Text("Deskripsi Lengkap")
                            .font(.custom("Poppins-Bold", size: 14))
                            .multilineTextAlignment(.center)
                        TextField("Deskripsikan semua di sini", text: $viewModel.deskripsi, axis: .vertical)
                            .font(.custom("Poppins-Regular", size: 14))
                            .frame(height: 100)
                            .padding()
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(descFocus ? Color(hex: LB.Colors.primaryColor) : .gray, lineWidth: 2)
                                    .opacity(descFocus ? 1 : 0.5)
                            )
                            .focused($descFocus)
                    }
   
//Button
                    
                    Button(action: {
                        viewModel.create() {
                            presentation.wrappedValue.dismiss()
                        } failure: { err in
                            print("Error saving firestore / storage:", err.localizedDescription)
                        }
                        
                    }, label: {
                        CustomButtonView(name: "Tambah Laporan")
                    })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Kirim Laporan")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
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
    }
}

#Preview {
    AddReportView()
}

