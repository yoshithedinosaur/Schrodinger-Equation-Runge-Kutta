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
