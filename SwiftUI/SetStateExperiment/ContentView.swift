//
//  ContentView.swift
//  SetStateExperiment
//
//  Created by pszot on 09/11/2019.
//  Copyright © 2019 szotp. All rights reserved.
//

import SwiftUI

struct MyHomePage: View {
    @State var counter: Int = 0
    
    init(initialCounter: Int) {
        counter = initialCounter
    }
    
    func incrementCounter() {
        counter += 1
    }
    
    var body: some View {
        return VStack {
            Text("You have pushed the button this many times:")
            Text("\(counter)").font(.largeTitle)
            Button(action: incrementCounter) {
                Text("Increment")
            }
        }.navigationBarTitle("SwiftUI Demo Home Page")
    }
}
