import Foundation
import ArgumentParser

struct AppClipCodeGenerator: ParsableCommand {
    @Option(name: .shortAndLong, help: "URL")
    var url: String
    
    @Option(name: [.short, .customLong("start")], help: "start id")
    var startId: Int
    
    @Option(name: [.short, .customLong("end")], help: "end id")
    var endId: Int?
    
    @Option(name: [.short, .customLong("color")], help: "default color template index")
    var colorTemplateIndex: String = "15"
    
    @Option(name: [.short, .customLong("folder")], help: "A file to save")
    var folderName: String = "AppClipCodeImage"
    
    @Flag(name: .shortAndLong, help: "show invoked url")
    var verbose = false
    
    mutating func run() throws {
        let urlPrefix = "\(url)/contact?id="
        var outputPath = "./" + folderName + "/"
        #if DEBUG
        outputPath = "~/Downloads/" + folderName + "/"
        #endif
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: outputPath) {
            do {
                try fileManager.createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        let endId = endId ?? startId
        for i in startId...endId {
            let fileName = "\(i).svg"
            let url = "\(urlPrefix)\(i)"
            if verbose {
                print(url)
            }
            
            generateCode(url: url,
                         colorTemplateIndex: colorTemplateIndex,
                         filePath: outputPath + fileName)
        }
    }
    
    private func generateCode(url: String, colorTemplateIndex index: String, filePath: String) {
        let command = "/usr/local/bin/AppClipCodeGenerator"
        
        let arguments = ["generate",
                         "--url", url,
                         "--index", index,
                         "--output", filePath]
        do {
            try Process.execute(command, arguments: arguments)
        } catch {
            print(error.localizedDescription)
        }
    }
}

AppClipCodeGenerator.main()
