//
//  RideType.swift
//  UberSwiftUI
//
//  Created by Shivankit on 23/06/24.
//

import Foundation

///CaseIterable this will wrap our all cases in one go

enum RideType: Int, CaseIterable, Identifiable{
    
    case uberX
    case black
    case uberXL
    case uberComfort
    
    var id: Int { return rawValue }
    
    var description: String{
        switch self{
        case .uberX:   return "Uber x"
        case .black:   return "UberBlack"
        case .uberXL:  return "UberXL"
        case .uberComfort:
            return "UberXxL"
        }
    }
    
    var imageName: String{
        switch self{
        case .uberX:   return "uber-x"
        case .black:   return "uber-black"
        case .uberXL:  return "UberXIcon"
        case .uberComfort:
            return "uber-black"
        }
    }
    
    var baseFare: Double{
        switch self{
        case .uberX:   return 5
        case .black:   return 20
        case .uberXL:  return 10
        case .uberComfort: return 45
        }
    }
    
    func computePrice(for distanceIneters: Double) -> Double{
        let distanceInMiles = distanceIneters / 1600
        
        switch self{
        case .uberX:   return distanceInMiles * 1.5 + baseFare
        case .black:   return distanceInMiles * 2.5 + baseFare
        case .uberXL:  return distanceInMiles * 3.5 + baseFare
        case .uberComfort: return distanceInMiles * 5.5 + baseFare
        }
        
        
    }
}
