//
//  LocationSearchView.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewModel
    var body: some View {
        VStack{
            //header view
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6,height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1,height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6,height: 6)
                }
                
                VStack{
                    TextField("Current location",text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    TextField("Where to?",text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top,64)
            
            Divider()
                .padding(.vertical)
            
            ScrollView {
                VStack(alignment: .leading){
                    ForEach(viewModel.result, id: \.self){ result in
                        LocationSearchResultCell(title: result.title, subTitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.selectedLocation(result)
                                    mapState = .locationSelected
                                }
                            }
                    }
                    
                }
            }
            
            //list view
        }
        .background(.white)
    }
}

#Preview {
    LocationSearchView(mapState: .constant(.searchigForLocation))
}
