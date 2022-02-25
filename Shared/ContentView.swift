//
//  ContentView.swift
//  Shared
//
//  Created by Yoshinobu Fujikake on 2/25/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var potentialSelect = "Square Well"
    
    //Choices set up
    let potentialsChoices = ["Square Well", "Linear Well", "Parabolic Well", "Square + Linear Well", "Square Barrier", "Triangle Barrier", "Coupled Parabolic Well", "Coupled Square Well + Field", "Harmonic Oscillator"/*, "Kronig - Penney", "Variable Kronig - Penney", "KP2-a"*/]
    
    var body: some View {
        VStack {
            Text("Choose Potential Well")
            Picker("Pick orbital 1:", selection: $potentialSelect) {
                ForEach(potentialsChoices, id: \.self) {
                    Text($0)
                }
            }
        }
        .frame(width: 400, height: 40)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
