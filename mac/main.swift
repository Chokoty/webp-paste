import AppKit
import Foundation

let args = CommandLine.arguments
if let i = args.firstIndex(of: "--convert"), args.count >= i + 3 {
  convertCLI(input: args[i + 1], output: args[i + 2])
  exit(0)
}
if args.contains("--once") {
  convertOnce()
  exit(0)
}
if args.contains("--toast") {
  let app = NSApplication.shared
  app.setActivationPolicy(.accessory)
  let toast = Toast()
  toast.show("63.3 KB → 8.6 KB (−86%)")
  DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) { exit(0) }
  app.run()
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
