//
//  Runge Kutta.swift
//  Schrodinger Equation Runge Kutta
//
//  Created by Yoshinobu Fujikake on 2/25/22.
//

import Foundation

class EigenEnergyFinder: ObservableObject {
    @Published var eigenEnergies: [String] = []
    var tempPoints: [(xPoint: Double, yPoint: Double)] = []
    var thresholdVal = Double(0.001)
    var currentPoint: Int = 1

    func calculateEigenEnergy(potentialType: String) -> [String] {
        let oneDSchrodinger = OneDSchrodinger()
        let potentialWells = PotentialWells()
        let deltaE = 0.01
        var yPotentialWellData: [Double] = []
        var xVals: [Double] = []
        var yVals: [Double] = []
        //var rootPoints: [String] = []
        
        let xMin = 0.0
        let xMax = 10.0
        let xStep = 0.01
        let potentials = potentialWells.getPotential(potentialType: potentialType, xMin: xMin, xMax: xMax, xStep: xStep/2.0)
        
        currentPoint = 1
        tempPoints.removeAll()
        eigenEnergies.removeAll()
        xVals.removeAll()
        yVals.removeAll()
        yPotentialWellData.removeAll()
        
        for i in 0...potentials.endIndex-1 {
            yPotentialWellData.append(potentials[i][.Y]!)
        }
    
        let dataPoints = oneDSchrodinger.functionalData(potentialsVals: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: 0.0)
    
        for i in 0...dataPoints.count-1 {
            xVals.append(dataPoints[i][.X]!)
            yVals.append(dataPoints[i][.Y]!)
        }
        
        while (xVals[currentPoint] != 100 && (currentPoint < xVals.count-1)) {
            let rootPoint = rootIntervalFinding(startIndex: currentPoint, xVals: xVals, yVals: yVals)
            if rootPoint.xPoint != 100 {
                tempPoints.append(rootPoint)
            }
            //print("WHILE INTERVAL"+String(currentPoint))
        }
        print(tempPoints)
        
        for i in 0..<tempPoints.count {
            
            let eigenEnergy = newtonRaphson(oneDSchrodinger: oneDSchrodinger, yPotentialWellData: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, tempPoints: tempPoints[i], deltaE: deltaE)
            
            eigenEnergies.append("\(eigenEnergy)")
            
            /*let deltaEWaveFunc = oneDSchrodinger.RK4(potentialsVals: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: 0.0, energy: tempPoints[i].xPoint + deltaE)
            let lastPoint = deltaEWaveFunc[deltaEWaveFunc.count-1][.Y]!
            let slope = (lastPoint - tempPoints[i].yPoint)/deltaE
            let newEnergyVal = tempPoints[i].xPoint - tempPoints[i].yPoint / slope
            let newEValWaveFunc = oneDSchrodinger.RK4(potentialsVals: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: 0.0, energy: newEnergyVal)
            let newEValPoint = newEValWaveFunc[newEValWaveFunc.count-1][.Y]!
            
            if abs(newEValPoint) < thresholdVal {
                
                return newEnergyVal
                
            } else {
                
            }*/
        }
        
        eigenEnergies.removeLast()
        print(eigenEnergies)

        return eigenEnergies
    
    }


    func rootIntervalFinding(startIndex: Int, xVals: [Double], yVals: [Double]) -> (xPoint: Double, yPoint: Double) {
        var yCurrent = yVals[startIndex]
        var yBefore = yVals[startIndex-1]
        var xCurrent = 0.0
        var xBefore = 0.0
        var counts: Int = 1
        
        while ((sign(valToCheck: yCurrent) == sign(valToCheck: yBefore)) && (startIndex + counts < yVals.count-1)) {
            
            
            yCurrent = yVals[startIndex + counts]
            yBefore = yVals[startIndex + counts - 1]
            
            counts += 1
            //print("MORE WHILE INTERVAL")
        }
        if (startIndex + counts == yVals.count-1) {
            currentPoint = startIndex + counts
            return (xPoint: xCurrent, yPoint: 0.0)
        }
        currentPoint = startIndex + counts
        xCurrent = xVals[currentPoint]
        xBefore = xVals[currentPoint - 1]
        
        return (xPoint: xCurrent, yPoint: yCurrent)
        
    }



    func newtonRaphson(oneDSchrodinger: OneDSchrodinger, yPotentialWellData: [Double], xMin: Double, xMax: Double, xStep: Double, tempPoints: (xPoint: Double, yPoint: Double), deltaE: Double) -> Double {
        
        let deltaEWaveFunc = oneDSchrodinger.RK4(potentialsVals: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: 0.0, energy: tempPoints.xPoint + deltaE)
        let lastPoint = deltaEWaveFunc[deltaEWaveFunc.count-1][.Y]!
        let slope = (lastPoint - tempPoints.yPoint)/deltaE
        let newEnergyVal = tempPoints.xPoint - tempPoints.yPoint / slope
        let newEValWaveFunc = oneDSchrodinger.RK4(potentialsVals: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: 0.0, energy: newEnergyVal)
        let newEValPoint = newEValWaveFunc[newEValWaveFunc.count-1][.Y]!
        
        if abs(newEValPoint) < thresholdVal {
            
            return newEnergyVal
            
        } else {
            return newtonRaphson(oneDSchrodinger: oneDSchrodinger, yPotentialWellData: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, tempPoints: (xPoint: newEnergyVal, yPoint: newEValPoint), deltaE: deltaE)
        }
    }
    
    
    
    func sign(valToCheck: Double) -> Int {
        if valToCheck > 0.0 {
            return 1
        } else if valToCheck < 0.0 {
            return -1
        } else {
            return 0
        }
    }

}
