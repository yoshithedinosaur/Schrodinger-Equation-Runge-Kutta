//
//  Runge Kutta.swift
//  Schrodinger Equation Runge Kutta
//
//  Created by Yoshinobu Fujikake on 2/25/22.
//

import Foundation

func calculateEigenEnergy(potentialType: String, xMin: Double, xMax: Double, xStep: Double) {
    let potentialWell = PotentialWells()
    let oneDSchrodinger = OneDSchrodinger()
    var functionalData: [(energyPoint: Double, psiPoint: Double)] = []
    var yPotentialWellData: [Double] = []
    
    potentialWell.getPotential(potentialType: potentialType, xMin: xMin, xMax: xMax, xStep: xStep)
    yPotentialWellData = oneDSchrodinger.oneDPotentialYArray
    
    oneDSchrodinger.functionalData(potentialsVals: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: 0.0)
    functionalData = oneDSchrodinger.psiEndPoints
}


func rootFinding() {
    
}
