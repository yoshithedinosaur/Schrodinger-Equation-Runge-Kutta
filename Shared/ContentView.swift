//
//  ContentView.swift
//  Shared
//
//  Created by Yoshinobu Fujikake on 2/25/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @ObservedObject var plotDataModel = PlotDataClass(fromLine: true)
    @ObservedObject private var potentialPlotter = PlotPotentials()
    @ObservedObject private var waveFunctionPlotter = PlotWaveFunctions()
    @ObservedObject private var functionalPlotter = PlotFunctional()
    @ObservedObject private var potentialWells = PotentialWells()
    @ObservedObject private var oneDSchrodinger = OneDSchrodinger()
    
    @State private var potentialSelect = "Square Well"
    @State private var viewSelect = "Potential"
    @State var eigenEnergyView = ""
    
    //Choices set up
    let potentialsChoices = ["Square Well", "Linear Well", "Parabolic Well", "Square + Linear Well", "Square Barrier", "Triangle Barrier", "Coupled Parabolic Well", /*"Coupled Square Well + Field", "Harmonic Oscillator", "Kronig - Penney", "Variable Kronig - Penney", "KP2-a"*/]
    let viewChoices = ["Potential", "Functional", "Wave Function"]
    var eigenEnergyList: [String] = []
    
    var body: some View {
        HStack{
            VStack {

                Text("Choose Potential Well")
                Picker("", selection: $potentialSelect) {
                    ForEach(potentialsChoices, id: \.self) {
                        Text($0)
                    }
                }
                
                Text("Choose View")
                Picker("", selection: $viewSelect) {
                    ForEach(viewChoices, id: \.self) {
                        Text($0)
                    }
                }
                /*.onReceive([self.viewSelect].publisher.first()) { potentialSelect in
                    plotPotentialWells(potentialType: potentialSelect)
                }*/ //Figure out later
                
                Text("Eigen Energies")
                Picker("", selection: $eigenEnergyView) {
                    ForEach(eigenEnergyList, id: \.self) {
                        Text($0)
                    }
                }
            }
            .frame(width: 400, height: 40)
            .padding()
            
            VStack{
                CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                    .setPlotPadding(left: 10)
                    .setPlotPadding(right: 10)
                    .setPlotPadding(top: 10)
                    .setPlotPadding(bottom: 10)
                    .padding()
                            
                Divider()
                            
                HStack{
                    Button("Plot Selected View", action: {self.plotButton(viewChoice: viewSelect, potentialType: potentialSelect)} )
                        .padding()
                                
                }
            }
        }
    }
    
    func plotButton (viewChoice: String, potentialType: String) {
        switch viewChoice {
        case "Potential":
            plotPotentialWells(potentialType: potentialType)
            
        case "Functional":
            plotFunctional(potentialType: potentialType)
            
        case "Wave Function":
            if (eigenEnergyView != "") {
            plotWaveFuncion(potentialType: potentialType, eigenEnergyVal: eigenEnergyView)
            }
        default:
            print("Don't know how you got here but ok.")
        }
    }
    
    func plotPotentialWells(potentialType: String){
                
        //pass the plotDataModel to the potentialPlotter
        potentialPlotter.plotDataModel = self.plotDataModel
        //Calculate the new plotting data and place in the plotDataModel
        potentialPlotter.plotWells(potentialType: potentialType)
        
    }
    
    func plotWaveFuncion(potentialType: String, eigenEnergyVal: String) {
        
        //pass the plotDataModel to the waveFunctionPlotter
        waveFunctionPlotter.plotDataModel = self.plotDataModel
        //Calculate the new plotting data and place in the plotDataModel
        waveFunctionPlotter.plotWaveFunction(potentialType: potentialType, energyVal: Double(eigenEnergyView)!)
        
    }
    
    func plotFunctional(potentialType: String) {
        //pass the plotDataModel to the waveFunctionPlotter
        functionalPlotter.plotDataModel = self.plotDataModel
        //Calculate the new plotting data and place in the plotDataModel
        functionalPlotter.plotFunctional(potentialType: potentialType)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
