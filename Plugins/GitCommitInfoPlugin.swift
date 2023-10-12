import PackagePlugin
import Foundation

@main
struct GitCommitInfoPlugin: BuildToolPlugin {
    static let toolName = "GitCommitInfoGenerator"
    static let outputFileName = "GitCommitInfo.swift"
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext,
                             target: Target) async throws -> [Command] {
        let generatorTool = try context.tool(named: Self.toolName)
        let outputPath = context.pluginWorkDirectory.appending(Self.outputFileName)
        return [gitCommitInfoBuildCommand(generatorTool: generatorTool, outputPath: outputPath)]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension GitCommitInfoPlugin: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext,
                             target: XcodeTarget) throws -> [Command] {
        let generatorTool = try context.tool(named: Self.toolName)
        let outputPath = context.pluginWorkDirectory.appending(Self.outputFileName)
        return [gitCommitInfoBuildCommand(generatorTool: generatorTool, outputPath: outputPath)]
    }
}

#endif

extension GitCommitInfoPlugin {
    func gitCommitInfoBuildCommand(generatorTool: PluginContext.Tool,
                                   outputPath: Path ) -> Command{
        return .buildCommand(
            displayName: "Generating GitCommitInfo file",
            executable: generatorTool.path,
            arguments: [outputPath],
            outputFiles: [outputPath]
        )
    }
}
