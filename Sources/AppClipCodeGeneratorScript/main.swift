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
    
    @Option(name: .customLong("show"), help: "show final url")
    var printURL: Bool = false
    
    mutating func run() throws {
        let urlPrefix = "\(url)/contact?id="
        
        if let endId = endId {
            for i in startId...endId {
                let fileName = "\(i).svg"
                let url = "\(urlPrefix)\(i)"
                if printURL {
                    print(url)
                }
                
                generateCode(url: url,
                             colorTemplateIndex: colorTemplateIndex,
                             outputPath: "/Users/sujianhao/Downloads/AppClipCodeImage/" + fileName)
            }
        }
        let endId = endId ?? startId
        for i in startId...endId {
            let fileName = "\(i).svg"
            let url = "\(urlPrefix)\(i)"
            if printURL {
                print(url)
            }
            
            generateCode(url: url,
                         colorTemplateIndex: colorTemplateIndex,
                         outputPath: "/Users/sujianhao/Downloads/AppClipCodeImage/" + fileName)
        }
    }
    
    private func generateCode(url: String, colorTemplateIndex index: String, outputPath: String) {
        let command = "/usr/local/bin/AppClipCodeGenerator"
        
        let arguments = ["generate",
                         "--url", url,
                         "--index", index,
                         "--output", outputPath]
        try? Process.execute(command, arguments: arguments)
    }
}

AppClipCodeGenerator.main()
