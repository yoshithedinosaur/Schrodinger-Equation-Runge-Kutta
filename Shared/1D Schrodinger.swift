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
    @Published var energyVal = 0.0
    
    let hbar2overm = 7.63 //In units of eV * Å^2
    
    // Data structure of the data points
    var contentArray = [plotDataType]()
    var functionalContentArray = [plotDataType]()
    @Published var psiEndPoints: [(energyPoint: Double, psiPoint: Double)] = []
    
    /// RK1
    /// parameters;
    /// -xMin, xMax, xStep: Range and steps of for the algorithm
    /// -initVal: the initial value of the equation at the boundary (x,y)
    /// -init1Ord: the initial value of the first order derivative of the function at the boundary
    /// return:
    /// -contentArray: an array of the coordinates given by RK1
    func RK1 (potentialsVals: [Double], xMin: Double, xMax:Double, xStep: Double, initialPsi: Double, energy: Double) -> [plotDataType] {
        
        //let potentialWells = PotentialWells()
        
        //potentialWells.getPotential(potentialType: potentialType, xMin: xMin, xMax: xMax, xStep: xStep)
        
        var dataPoint: plotDataType = [:]
        contentArray.removeAll()
        var xVal = xMin
        var psi = initialPsi
        var psiPrime = 1.0 //Start with a guess for slope; normalize later
        var psiDoublePrime = 0.0
        var potential = 0.0 //eventually pull from potential well
        var count: Int = 0

        
        dataPoint = [.X: xVal, .Y: psi] //gives initial values first
        
        //for energy in stride(from: 0.0, to: 10000, by: 0.05) {
            
            for _ in stride(from: xMin, through: xMax, by: xStep) {
                if (count <= 1 || count == potentialsVals.endIndex) { potential = 0.0 } else {
                potential = potentialsVals[count-1]
                }
                var previousPsiPrime = psiPrime
                var previousPsi = psi
            
                psiDoublePrime = 2/hbar2overm * (potential - energy) * psi
                psiPrime = previousPsiPrime + xStep * psiDoublePrime
                psi = previousPsi + xStep * previousPsiPrime
            
                xVal += xStep //moving on to the next x value
                print("\(potentialsVals.endIndex)")
                dataPoint = [.X: xVal, .Y: psi]
                contentArray.append(dataPoint)
                count += 1
            }
        
        psiEndPoints.append( (energyPoint: energy, psiPoint: psi) )
            
        //    functionalDataPoint = [.X: energy, .Y: psi]
        //    functionalContentArray.append(functionalDataPoint)
            
        //}
        
        
        
        return contentArray
    }
    
    /// RK4
    /// parameters;
    /// -xMin, xMax, xStep: Range and steps of for the algorithm
    /// -initialPsi: the initial value of the equation at the boundary (x,y)
    /// -initialPsiPrime: the initial value of the first order derivative of the function at the boundary
    /// return:
    /// -contentArray:  an array of the coordinates given by RK4
    func RK4 (potentialsVals: [Double], xMin: Double, xMax:Double, xStep: Double, initialPsi: Double, energy: Double) -> [plotDataType] {
        
        //let potentialWells = PotentialWells()
        var dataPoint: plotDataType = [:]
        contentArray.removeAll()
        var xVal = xMin
        var psi = initialPsi
        var psiPrime = 1.0 //Start with a guess for slope; normalize later
        var psiDoublePrime = 0.0
        var potential = 0.0 //eventually pull from potential well
        var count: Int = 0
        var k1 = 0.0
        var k2 = 0.0
        var k3 = 0.0
        var k4 = 0.0
        var k1Prime = 0.0
        var k2Prime = 0.0
        var k3Prime = 0.0
        var k4Prime = 0.0
        
        dataPoint = [.X: xVal, .Y: psi] //gives initial values first
        
        
        
        for _ in stride(from: xMin, through: xMax, by: xStep) {
            if (count <= 1 || count == potentialsVals.endIndex) { potential = 0.0 } else {
            potential = potentialsVals[count-1]
            }
            var previousPsiPrime = psiPrime
            var previousPsi = psi
            psiDoublePrime = 2/hbar2overm * (potential - energy) * psi
            
            k1Prime = psiDoublePrime * previousPsi
            k1 = previousPsiPrime
            k2Prime = psiDoublePrime * (previousPsiPrime + xStep * k1Prime/2)
            k2 = previousPsiPrime + xStep * k1/2
            k3Prime = psiDoublePrime * (previousPsiPrime + xStep * k2Prime/2)
            k3 = previousPsiPrime + xStep * k2/2
            k4Prime = psiDoublePrime * (previousPsiPrime + xStep * k3Prime)
            k4 = previousPsiPrime + xStep * k3
            psiPrime = previousPsiPrime + xStep * (k1Prime + 2*k2Prime + 2*k3Prime +k4Prime)/6
            psi = previousPsi + xStep * (k1 + 2*k2 + 2*k3 + k4)/6
        
            xVal += xStep //moving on to the next x value
            print("\(potentialsVals.endIndex)")
            dataPoint = [.X: xVal, .Y: psi]
            contentArray.append(dataPoint)
            count += 1
        }
        
        return contentArray
    }
    
    func functionalData(potentialsVals: [Double], xMin: Double, xMax:Double, xStep: Double, initialPsi: Double) -> [plotDataType]{
        
        var functionalDataPoint: plotDataType = [:]
        functionalContentArray.removeAll()
        
        for energy in stride(from: 0.0, to: 100, by: 0.5) {
            RK4(potentialsVals: potentialsVals, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: initialPsi, energy: energy)
            
            functionalDataPoint = [.X: psiEndPoints[psiEndPoints.endIndex-1].energyPoint, .Y: psiEndPoints[psiEndPoints.endIndex-1].psiPoint]
            functionalContentArray.append(functionalDataPoint)
        }
        
        return functionalContentArray
        
    }

    
}
