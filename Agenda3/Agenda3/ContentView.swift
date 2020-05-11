//
//  ContentView.swift
//  Agenda3
//
//  Created by Naoki Matsumoto on 2020/05/11.
//  Copyright © 2020 Naoki Matsumoto. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
           Recent()
                .tabItem {
                    VStack {
                        Image(systemName: "clock")
                        Text("Recent")
                    }
            }.tag(1)
           Folder()
                .tabItem {
                    VStack {
                        Image(systemName: "folder")
                        Text("Folder")
                    }
            }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
