
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
//
	func applicationDidFinishLaunching(_: Notification) {}

	func applicationWillTerminate(_: Notification) {}

	func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
		return true
	}

}
