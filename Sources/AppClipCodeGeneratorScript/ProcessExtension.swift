//
//  File.swift
//  
//
//  Created by 蘇健豪 on 2021/5/25.
//

import Foundation

extension Process {
    
    public static func execute(_ command: String, arguments: [String]) throws {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: command)
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: String.Encoding.utf8) {
                #if DEBUG
                print(output)
                #endif
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
}
