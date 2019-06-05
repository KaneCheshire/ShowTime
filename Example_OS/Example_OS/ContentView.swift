//
//  ContentView.swift
//  Example_OS
//
//  Created by Kane Cheshire on 05/06/2019.
//  Copyright © 2019 kane.codes. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        Text("Hello World")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
