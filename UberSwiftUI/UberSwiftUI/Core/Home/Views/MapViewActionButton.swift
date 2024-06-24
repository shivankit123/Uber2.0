//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewModel
    var body: some View {
        Button{
            withAnimation(.spring()){
                actionForState(mapState)
            }
                    } label: {
                        Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    func actionForState(_ state: MapViewState){
        switch state{
        case .noInput:
            print("debug")
        case .searchigForLocation:
            mapState = .noInput
        case .locationSelected:
            mapState = .noInput
            viewModel.selectedUberLocationCoordinates = nil
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String{
        switch state{
        case .noInput:
            return "line.3.horizontal"
        case .searchigForLocation, .locationSelected:
            return "arrow.left"
        }
    }
}

#Preview {
    MapViewActionButton(mapState: .constant(.noInput))
}
