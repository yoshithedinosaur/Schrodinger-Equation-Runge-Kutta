//
//  PlotPotentialWells.swift
//  Schrodinger Equation Runge Kutta
//
//  Created by Yoshinobu Fujikake on 3/4/22.
//

import Foundation
import SwiftUI
import CorePlot

class PlotPotentials: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    let potentialWells = PotentialWells()
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.05
    
    @MainActor func plotWells(potentialType: String) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 10.0
        plotDataModel!.changingPlotParameters.yMin = 0.0
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = xMin
        plotDataModel!.changingPlotParameters.xLabel = "x"
        plotDataModel!.changingPlotParameters.yLabel = "E"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Potential Well"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        //makes potential wells data
        let dataPoints = potentialWells.getPotential(potentialType: potentialType, xMin: xMin, xMax: xMax, xStep: xStep)
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append(contentsOf: [dataPoints[i]])
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}

class PlotWaveFunctions: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    let waveFunction = OneDSchrodinger()
    //let potentialWells = PotentialWells()
    var yPotentialWellData: [Double] = []
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.05
    
    @MainActor func plotWaveFunction(potentialType: String, energyVal: Double) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 10.0
        plotDataModel!.changingPlotParameters.yMin = 0.0
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = xMin
        plotDataModel!.changingPlotParameters.xLabel = "x"
        plotDataModel!.changingPlotParameters.yLabel = "psi"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Wave Function"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        //potentialWells.getPotential(potentialType: potentialType, xMin: xMin, xMax: xMax, xStep: xStep)
        yPotentialWellData = waveFunction.oneDPotentialYArray
        
        //makes wave function data
        let dataPoints = waveFunction.RK4(potentialsVals: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: 0.0, energy: energyVal)
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append(contentsOf: [dataPoints[i]])
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}

class PlotFunctional: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    let functional = OneDSchrodinger()
    let potentialWells = PotentialWells()
    var yPotentialWellData: [Double] = []
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.05
    
    @MainActor func plotFunctional(potentialType: String) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 10.0
        plotDataModel!.changingPlotParameters.yMin = 0.0
        plotDataModel!.changingPlotParameters.xMax = 100
        plotDataModel!.changingPlotParameters.xMin = 0.0
        plotDataModel!.changingPlotParameters.xLabel = "E"
        plotDataModel!.changingPlotParameters.yLabel = "psi(L)"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Functional"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        let potentials = potentialWells.getPotential(potentialType: potentialType, xMin: xMin, xMax: xMax, xStep: xStep)
        
        yPotentialWellData.removeAll()
        for i in 0...potentials.endIndex-1 {
            yPotentialWellData.append(potentials[i][.Y]!)
        }
        
        //makes potential wells data
        let dataPoints = functional.functionalData(potentialsVals: yPotentialWellData, xMin: xMin, xMax: xMax, xStep: xStep, initialPsi: 0.0)
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append(contentsOf: [dataPoints[i]])
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}
