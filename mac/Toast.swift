import AppKit

final class Toast {
  private var panel: NSPanel?
  private var hideWork: DispatchWorkItem?

  func show(_ text: String, error: Bool = false) {
    hideWork?.cancel()
    let paper = NSColor(srgbRed: 0.937, green: 0.902, blue: 0.839, alpha: 1)
    let ink = NSColor(srgbRed: 0.102, green: 0.086, blue: 0.071, alpha: 1)
    let stamp = NSColor(srgbRed: 0.769, green: 0.235, blue: 0.067, alpha: 1)

    let label = NSTextField(labelWithString: text)
    label.font = NSFont.systemFont(ofSize: 13, weight: .medium)
    label.textColor = paper
    label.alignment = .center
    label.lineBreakMode = .byWordWrapping
    label.maximumNumberOfLines = 2
    label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    let padX: CGFloat = 16
    let padY: CGFloat = 10
    let maxWidth: CGFloat = 420
    label.preferredMaxLayoutWidth = maxWidth - padX * 2
    let fitting = label.fittingSize
    let width = min(max(fitting.width + padX * 2, 180), maxWidth)
    let height = fitting.height + padY * 2
    label.frame = NSRect(x: padX, y: padY, width: width - padX * 2, height: fitting.height)

    let screen = NSScreen.main ?? NSScreen.screens[0]
    let visible = screen.visibleFrame
    let frame = NSRect(
      x: visible.midX - width / 2,
      y: visible.minY + 24,
      width: width,
      height: height
    )

    let panel = self.panel ?? makePanel()
    self.panel = panel
    panel.backgroundColor = error ? stamp : ink
    panel.contentView?.subviews.forEach { $0.removeFromSuperview() }
    panel.contentView?.addSubview(label)
    panel.setFrame(frame, display: true)
    panel.alphaValue = 1
    panel.orderFrontRegardless()

    NSAccessibility.post(
      element: label,
      notification: .announcementRequested,
      userInfo: [.announcement: text as NSString]
    )

    let reduce = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
    let work = DispatchWorkItem { [weak self] in
      guard let panel = self?.panel else { return }
      if reduce {
        panel.orderOut(nil)
        return
      }
      NSAnimationContext.runAnimationGroup { ctx in
        ctx.duration = 0.18
        panel.animator().alphaValue = 0
      } completionHandler: {
        panel.orderOut(nil)
      }
    }
    hideWork = work
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.4, execute: work)
  }

  private func makePanel() -> NSPanel {
    let panel = NSPanel(
      contentRect: .zero,
      styleMask: [.borderless, .nonactivatingPanel],
      backing: .buffered,
      defer: true
    )
    panel.isFloatingPanel = true
    panel.level = .floating
    panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .ignoresCycle]
    panel.isOpaque = true
    panel.hasShadow = true
    panel.hidesOnDeactivate = false
    panel.becomesKeyOnlyIfNeeded = true
    panel.ignoresMouseEvents = true
    panel.animationBehavior = .none
    return panel
  }
}
