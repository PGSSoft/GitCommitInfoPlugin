//
//  ContentView.swift
//  Example
//
//  Created by Michal Kowalski on 17/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                VStack(alignment: .leading) {
                    Text("Commit hash").font(.caption)
                    Text(GitCommitInfo.commitHash)
                }
                VStack(alignment: .leading) {
                    Text("Branch name").font(.caption)
                    Text(GitCommitInfo.branchName)
                }
                VStack(alignment: .leading) {
                    Text("Short commit hash").font(.caption)
                    Text(GitCommitInfo.shortCommitHash)
                }
                VStack(alignment: .leading) {
                    Text("Commit message").font(.caption)
                    Text(GitCommitInfo.commitSubject)
                }
                VStack(alignment: .leading) {
                    Text("Timestamp").font(.caption)
                    Text("\(GitCommitInfo.unixTimestamp)")
                }
            }.navigationTitle("About")
        }
    }
}
