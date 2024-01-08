//
//  DataView.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 06/01/24.
//

import SwiftUI

struct CustomDivider: View {
    var height: CGFloat

    var body: some View {
        Rectangle()
            .frame(height: height)
    }
}

struct DataView: View {
    let Data: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(Data)
                .textCase(.lowercase)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: LB.Colors.primaryColor))
            
            CustomDivider(height: 2)
                .foregroundColor(Color(hex: LB.Colors.primaryColor))
                
            
        }
        .padding()
    }
}

#Preview {
    DataView(Data: "Test Data")
}
