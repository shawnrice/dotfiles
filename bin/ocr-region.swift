#!/usr/bin/env swift

import Cocoa
import Vision

let tmp = "/tmp/ocr-capture.png"

// Interactive region select (same UI as ⌘⇧4)
let proc = Process()
proc.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
proc.arguments = ["-i", tmp]
try proc.run()
proc.waitUntilExit()

guard proc.terminationStatus == 0,
      let img = NSImage(contentsOfFile: tmp),
      let cgImg = img.cgImage(forProposedRect: nil, context: nil, hints: nil)
else { exit(1) }

let req = VNRecognizeTextRequest()
req.recognitionLevel = .accurate
try VNImageRequestHandler(cgImage: cgImg).perform([req])

let text = (req.results ?? [])
    .compactMap { $0.topCandidates(1).first?.string }
    .joined(separator: "\n")

let pb = NSPasteboard.general
pb.clearContents()
pb.setString(text, forType: .string)

try? FileManager.default.removeItem(atPath: tmp)
