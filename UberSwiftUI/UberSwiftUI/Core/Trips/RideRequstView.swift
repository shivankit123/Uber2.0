//
//  RideRequstView.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import SwiftUI

struct RideRequstView: View {
    @State private var selectedRideType: RideType = .uberX
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width:48,height: 6)
                .padding(.top,8)
            
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8,height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1,height: 32)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8,height: 8)
                }
                
                VStack(alignment: .leading,spacing: 24){
                    HStack{
                        Text("Current Location")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("1:30 PM")
                            .font(.system(size: 14,weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom,10)
                    HStack{
                        if let location = locationViewModel.selectedUberLocationCoordinates{
                            Text(location.title)
                                .font(.system(size: 16,weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("5:30 PM")
                            .font(.system(size: 14,weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading,8)
            }
            .padding()
            
            Divider()
            
            Text("Suggested rides").textCase(.uppercase)
                .font(.system(size: 14,weight: .semibold))
                .padding()
                .foregroundColor(Color(.gray))
                .frame(maxWidth: .infinity,alignment: .leading)
            
            
            ScrollView(.horizontal){
                HStack(spacing: 12) {
                    ForEach(RideType.allCases, id: \.self) { type in
                        VStack(alignment: .leading){
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                            VStack(alignment:.leading,spacing: 4){
                                Text(type.description)
                                    .font(.system(size: 14,weight: .semibold))
                                    
                                Text(locationViewModel.computeRidePrice(forType: type).toCurrency())
                                    .font(.system(size: 14,weight: .semibold))
                            }
                            .padding(8)
                            
                        }
                        
                        .frame(width: 112,height: 140)
                        .foregroundColor(type == selectedRideType ? .white : .black)
                        .background(Color(type == selectedRideType ? .systemBlue : .systemGroupedBackground))
                        .cornerRadius(10)
                        .scaleEffect(type == selectedRideType ? 1.2 : 1.0)
                        .onTapGesture {
                            withAnimation(.spring()){
                                selectedRideType = type
                            }
                        }
                        
                        
                    }
                    
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical,8)
            //payment
            
            HStack(spacing: 12){
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("**** 3641")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
            }
            .frame(height:50)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Divider()
            
            Button{
                
            }label: {
                Text("Confirm Ride").textCase(.uppercase)
                    .frame(width:UIScreen.main.bounds.width - 30,height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
            }
        }
        .padding(.bottom,16)
        .background(Color.theme.bgColor)
        .cornerRadius(16)
    }
}

#Preview {
    RideRequstView()
}
