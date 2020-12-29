import UIKit
import Combine

final class WriteTextViewController: UIViewController {
	var viewModel: WriteTextViewModelInput?
	var onEndThisFlow: (() -> Void)?

    @IBOutlet private weak var memsText: UITextView!
    @IBOutlet private weak var charCounter: UILabel!
    @IBOutlet private weak var clearText: UIButton!
    @IBOutlet private weak var sendButton: UIButton!

	private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.subscribeOnVMUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.zeroState()
    }
    
    private func setupUI() {
        self.memsText.layer.shadowColor = UIColor.black.cgColor
        self.memsText.layer.shadowOpacity = 1
        self.memsText.layer.shadowOffset = .zero
        self.memsText.layer.shadowRadius = 5
        self.memsText.clipsToBounds = false
         
        self.charCounter.text = "\(self.memsText.text.count) / 50"
        self.clearText.addTarget(self, action: #selector(clearBtnPressed), for: .touchUpInside)
    }
    
    private func zeroState() {
        self.memsText.text = "Напиши что-нибудь тут..."
        self.charCounter.text = "\(self.memsText.text.count) / 50"
    }
    
    @objc private func clearBtnPressed() {
        self.viewModel?.clearText()
    }
    
    @IBAction private func sendButtonAction(_ sender: UIButton) {
        guard let text = self.memsText.text else { return }
        self.viewModel?.sendText(text)
    }
    
    private func subscribeOnVMUpdates() {
        self.viewModel?.memTextUpdateSubject
            .sink { [weak self] textModel in
                guard let model = textModel else { return }
                self?.memsText.text = model.memText
                self?.charCounter.text = model.charCounter
                self?.sendButton.isHidden = model.sendButtonHidden
            }
            .store(in: &self.subscriptions)
        self.viewModel?.currentError
            .sink { [weak self] error in
                guard let strongSelf = self else { return }
                guard let error = error?.error else {
                    guard !strongSelf.sendButton.isHidden else { return }
                    strongSelf.onEndThisFlow?()
                    return
                }
                strongSelf.showError(title: "Error", message: error)
            }
            .store(in: &self.subscriptions)
    }
}

extension WriteTextViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,  replacementText text: String) -> Bool {
        return self.memsText.text.count + (text.count - range.length) <= 50
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel?.textDidChange(textView.text)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.viewModel?.textBeginEditing()
    }
}
