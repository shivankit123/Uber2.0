//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import SwiftUI

struct HomeView: View {
    
  
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    var body: some View {
        ZStack(alignment: .bottom){
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchigForLocation{
                    LocationSearchView(mapState: $mapState)
                }else if mapState == .noInput{
                    LocationSearchActivation()
                        .padding(.top,70)
                        .onTapGesture {
                            withAnimation(.spring()){
                                mapState = .searchigForLocation
                            }
                        }
                }
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            
            if mapState == .locationSelected{
                RideRequstView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation){ location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
            
    }
}

#Preview {
    HomeView()
}
