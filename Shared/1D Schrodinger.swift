//
//  1D Schrodinger.swift
//  Schrodinger Equation Runge Kutta
//
//  Created by Yoshinobu Fujikake on 2/25/22.
//

import Foundation

class OneDSchrodinger: ObservableObject {
    
    @Published var oneDPotentialArray: [(xCoord: Double, Potential: Double)] = []
    @Published var oneDPotentialXArray: [Double] = []
    @Published var oneDPotentialYArray: [Double] = []
    
    
    /*
     2         2
 hbar   partial
- ----- ---------- psi  +  (V  -  E)psi  =  0
  2m            2
       partial x
     */
    func schrodingerEq () {
        
    }
    
    
    func minX(minArray: [Double]) -> Double {
        var minX: Double = 0.0
        
        return minX
    }
    
    func maxX(maxArray: [Double]) -> Double {
        var maxX: Double = 0.0
        
        return maxX
    }
    
    func minY(minArray: [Double]) -> Double {
        var minY: Double = 0.0
        
        return minY
    }
    
    func maxY(maxArray: [Double]) -> Double {
        var maxY: Double = 0.0
        
        return maxY
    }
    
}
