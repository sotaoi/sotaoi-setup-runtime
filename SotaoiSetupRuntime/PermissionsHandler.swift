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
      self.accessibilityPermission()
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
  
  func accessibilityPermission() -> Void {
    self.viewController.dialog("Requesting accessibility permission", "Allow?", {
      self.viewController.alert("Accessibility permission granted, proceeding...", { /* Do nothing */ })
    })
  }
  
  /* --- --- --- */
}
