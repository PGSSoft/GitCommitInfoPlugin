//
//  main.swift
//  GitCommitInfoGenerator
//
//  Created by Michal Kowalski on 03/10/2023.
//

import Foundation

let args = CommandLine.arguments
let outputFile = args[1]

struct GitHelper {

    static private func projectDir() -> String {
        ProcessInfo.processInfo.environment["PROJECT_DIR"]!
    }

    static private func shell(_ command: String) -> String {
        let process = Process()
        let pipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = pipe
        process.standardError = errorPipe
        process.arguments = ["-c", command]
        process.launchPath = "/bin/zsh"
        process.launch()

        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        guard errorData.isEmpty else {
            fatalError("Error executing shell command \(String(data: errorData, encoding: .utf8)!)")
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }

    static func gitCommand(_ cmd: String) -> String {
        "\(shell("cd \(projectDir()) && \(cmd)").trimmingCharacters(in: .whitespacesAndNewlines))"
    }

}

let commitHash = GitHelper.gitCommand("git log -1 --pretty=\"%H\"")
let shortCommitHash = GitHelper.gitCommand("git log -1 --pretty=\"%h\"")
let shortSubject = GitHelper.gitCommand("git log -1 --pretty=\"%s\"")
let branchName = GitHelper.gitCommand("git rev-parse --abbrev-ref HEAD")
let timestamp = GitHelper.gitCommand("git log -1 --pretty=\"%ct\"")

let content = """
struct GitCommitInfo {

    static var commitHash: String {
        "\(commitHash)"
    }

    static var shortCommitHash: String {
        "\(shortCommitHash)"
    }

    static var commitSubject: String {
        "\(shortSubject)"
    }

    static var branchName: String {
        "\(branchName)"
    }

    static var unixTimestamp: Double {
        \(timestamp)
    }
}
"""

do {
    try content.data(using: .utf8)?.write(to: URL(fileURLWithPath: outputFile))
} catch {
    fatalError(error.localizedDescription)
}
