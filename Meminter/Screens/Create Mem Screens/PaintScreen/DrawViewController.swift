import UIKit

final class DrawViewController: UIViewController {
    @IBOutlet private weak var menuView: MenuView!
    @IBOutlet private weak var xMenuPos: NSLayoutConstraint!
    @IBOutlet private weak var menuButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    
    private let drawView = DrawView()
    var viewModel: DrawViewModelInput?
    var onEndThisFlow: (() -> Void)?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.onError = { [weak self] error in
			self?.showError(title: "Error", message: error)
        }
		self.viewModel?.onSuccess = { [weak self] in
			self?.onEndThisFlow?()
		}
        NotificationCenter.default.addObserver(forName: MenuView.MenuViewDrawingParamDidChangedNotification, object: nil, queue: nil, using: drawingParamsChangedNotification)
        
        self.view.addSubview(self.drawView)
        self.drawView.frame = self.view.bounds
        self.view.sendSubviewToBack(self.drawView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.drawView.clear()
        self.sendButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.viewModel?.userDefaultsProvider.checkFor(key: .isFirstAppear) != true {
            self.wowwowEasy(#imageLiteral(resourceName: "tapok"), title: "Нарисуй свой мем", message: "Рисуй - экран не заминирован!")
        }
    }
  
    //MARK: - actions for buttons
    
    @IBAction private func clear(_ sender: UIButton) {
        self.drawView.clear()
        self.sendButton.isHidden = true
        sender.springButtonAnimation(animatedElement: sender, duration: 1)
    }
    
    @IBAction private func redo(_ sender: UIButton) {
        drawView.redo()
        sender.springButtonAnimation(animatedElement: sender, duration: 1)
        self.sendButton.isHidden = self.drawView.layers.isEmpty
    }
    
    @IBAction private func undo(_ sender: UIButton) {
        self.drawView.undo()
        sender.springButtonAnimation(animatedElement: sender, duration: 1)
        self.sendButton.isHidden = self.drawView.layer.sublayers?.isEmpty == nil
    }
    
    @IBAction private func showMenu(_ sender: UIButton) {
        sender.springButtonAnimation(animatedElement: sender, duration: 1)
        self.setVisibleMenu(!self.menuView.visible)
    }
    
    @IBAction private func save(_ sender: UIButton) {
        sender.springButtonAnimation(animatedElement: sender, duration: 1)
        if let image = self.drawView.uiImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @IBAction private func sendButtonAction(_ sender: UIButton) {
        self.viewModel?.postImage(self.drawView.uiImage?.jpegData(compressionQuality: 0.5))
    }
    
    //MARK: - touches processing
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.menuView.visible {
            self.setVisibleMenu(!self.menuView.visible)
        }
        self.sendButton.isHidden = false
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: - notification response
    
    private func drawingParamsChangedNotification(notification: Notification) -> Void {
        if let params = notification.object as? [String: Any], let lineWidth = params["lineWidth"] as? Float {
            self.drawView.lineWidth = CGFloat(lineWidth)
            self.drawView.color = params["color"] as! UIColor
        }
    }
    
    //MARK: - menu display
    
    private func setVisibleMenu(_ visible: Bool) {
        self.menuView.visible = visible
        UIView.animate(withDuration: 0.3) {
            self.xMenuPos.constant = visible ? 0 : -self.menuView.frame.width
            self.view.layoutIfNeeded()
        }
        self.menuView.isHidden = !visible
    }
    
    //MARK: - saving image responce
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.showError(title: "Error", message: error.localizedDescription)
        } else {
            self.showError(title: "Success", message: "Image saved")
        }
    }
}
