import Cocoa
import AVFoundation

@available(macOS 10.15, *)
class PermissionsHandler {
  var viewController: ViewController!
  
  func run(_ viewController: ViewController) -> Void {
    self.viewController = viewController
    self.viewController.dialog("Starting runtime", "Continue?", {
      self.requestPermissions()
    })
  }
  
  func requestPermissions() -> Void {
    self.screenRecordingPermission({
      self.accessibilityPermission({
        self.runAutomation()
      })
    })
  }
  
  /* --- --- --- */
  
  func screenRecordingPermission(_ next: @escaping () -> Void) -> Void {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .authorized: // The user has previously granted access to the camera.
      self.viewController.alert("Screen recording permission granted, proceeding...", { next() })
      case .notDetermined: // The user has not yet been asked for camera access.
        AVCaptureDevice.requestAccess(for: .video) { granted in
          if granted {
            self.viewController.alert("Screen recording permission granted, proceeding...", { next() })
          }
        }
      case .denied: // The user has previously denied access.
        self.viewController.alert("Screen recording permission was previously denied", { next() })
      case .restricted: // The user can't grant access due to restrictions.
        self.viewController.alert("Screen recording permission denied", { next() })
    @unknown default:
      self.viewController.alert("Unknown screen recording authorization status", { next() })
    }
  }
  
  func accessibilityPermission(_ next: @escaping () -> Void) -> Void {
    self.viewController.dialog("Requesting accessibility permission", "Allow?", {
      self.viewController.alert("Accessibility permission granted, proceeding...", { next() })
    })
  }

  func runAutomation() -> Void {
    self.viewController.alert("Running automation...", {
      self.takeScreenshot()
    })
  }

  func takeScreenshot() {
    var displayCount: UInt32 = 0;
    var result = CGGetActiveDisplayList(0, nil, &displayCount)
    if (result != CGError.success) {
      print("error: \(result)")
      return
    }
    let allocated = Int(displayCount)
    let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
    result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)

    if (result != CGError.success) {
      print("error: \(result)")
      return
    }

    // todo here: figure out which display to print

    let fileUrl = URL(fileURLWithPath: "/Users/qwertypnk/Downloads/sotaoi_setup_screenshot.jpg", isDirectory: false)
    let screenShot: CGImage = CGDisplayCreateImage(activeDisplays[Int(0)])!
    let bitmapRep = NSBitmapImageRep(cgImage: screenShot)
    let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!

    do {
      try jpegData.write(to: fileUrl, options: .atomic)
    } catch {
      print("error: \(error)")
    }

    //for i in 1...displayCount {
    //  let fileUrl = URL(fileURLWithPath: "/Users/qwertypnk/Downloads/sotaoi_setup_screenshot.jpg", isDirectory: false)
    //  let screenShot:CGImage = CGDisplayCreateImage(activeDisplays[Int(i-1)])!
    //  let bitmapRep = NSBitmapImageRep(cgImage: screenShot)
    //  let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
    //
    //  do {
    //    try jpegData.write(to: fileUrl, options: .atomic)
    //  } catch {
    //    print("error: \(error)")
    //  }
    //}
  }
  
  /* --- --- --- */
}
