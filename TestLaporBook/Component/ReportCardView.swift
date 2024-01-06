//
//  ReportCardView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 03/01/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReportCardView: View {
    @Environment(\.colorScheme) var colorScheme
    var data: ReportModel?
    
    var body: some View {
        ZStack{
//Images
            VStack(alignment: .leading, spacing: 0) {
                WebImage(url: URL(string: data?.imgPath ?? ""))
                    .resizable()
                
                //Placeholder
                    .placeholder(content: {
                        ProgressView()
                            .font(.title)
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.height * 0.3)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    })
                
                    .onFailure(perform: { _ in
                        VStack(spacing: 16) {
                            Image(systemName: "wifi.slash")
                                .font(.largeTitle)
                            Text("Gagal mendownload")
                        }
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.width * 0.28)
                    .clipped()
                
                //Judul
                VStack(spacing: 0) {
                    Divider()
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                        .overlay(.black)
                        .multilineTextAlignment(.center)
                    Text("\(data?.title ?? "Title")")
                        .padding()
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .lineLimit(2)
                        .font(.title2)
                        .fontWeight(.bold)
                        
                    Divider()
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                        .overlay(.black)
                    
                    //Data
                    HStack(spacing: 0){
                        VStack{
                            Text(data?.status ?? "")
                                .foregroundStyle(.white)
                                .padding()
                                .font(.system(size: 12))
                        }
                        .background(getBackgroundColor(for: data?.status))
                        Divider()
                            .frame(width: 2)
                            .overlay(.black)
                        VStack{
                            Text("\(formatDate(data?.date ?? Date()))")
                                .foregroundStyle(.white)
                                .padding()
                                .font(.system(size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                    }
                }
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2)
        )
    }

    
//Date Thing
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    
//BG Color
    func getBackgroundColor(for status: String?) -> Color {
        switch status {
        case "Posted":
            return Color(hex: LB.AppColors.successColor)
//            return Color(hex: LB.AppColors.dangerColor)
        case "Process":
            return Color(hex: LB.AppColors.warningColor)
        case "Done":
            return Color(hex: LB.AppColors.successColor)
        default:
            return Color(hex: LB.AppColors.successColor)
            
            //Testo
        }
    }
}

#Preview {
    ReportCardView()
        .frame(height: 300)
}
