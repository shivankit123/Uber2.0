//
//  LocationSearchResultCell.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title: String
    let subTitle: String
    var body: some View {
        HStack{
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .accentColor(.white)
                .frame(width: 40,height: 40)
            
            VStack(alignment: .leading, spacing: 4){
                Text(title)
                    .font(.body)
                
                Text(subTitle)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                Divider()   //give the line below this HStack
            }
            .padding(.leading,8)
            .padding(.vertical,8)
        }
        .padding(.leading)
    }
}

#Preview {
    LocationSearchResultCell(title: "Starbucks", subTitle: "123 Main st")
}
