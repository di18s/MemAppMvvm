import UIKit

final class WriteTextViewController: UIViewController {
    @IBOutlet private weak var memsText: UITextView!
    @IBOutlet private weak var charCounter: UILabel!
    @IBOutlet private weak var clearText: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    
    private var isFirstClearText = true

    var viewModel: WriteTextViewModelInput?
    var onEndThisFlow: (() -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.viewModel?.onError = { [weak self] error in
            if let error = error {
                self?.showError(title: "Error", message: error)
            } else {
                self?.onEndThisFlow?()
            }
        }
    }
    
    private func setupUI() {
        self.memsText.layer.shadowColor = UIColor.black.cgColor
        self.memsText.layer.shadowOpacity = 1
        self.memsText.layer.shadowOffset = .zero
        self.memsText.layer.shadowRadius = 5
        self.memsText.clipsToBounds = false
 
        self.charCounter.text = String(self.memsText.text.count) + " / 50"
        self.clearText.addTarget(self, action: #selector(clearBtnPressed), for: .touchUpInside)
    }
    
    @objc private func clearBtnPressed () {
        self.memsText.text = ""
        self.charCounter.text = String(self.memsText.text.count) + " / 50"
        self.sendButton.isHidden = true
    }
    
    @IBAction private func sendButtonAction(_ sender: UIButton) {
        guard let text = self.memsText.text else { return }
        self.viewModel?.sendText(text)
    }
}

extension WriteTextViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,  replacementText text: String) -> Bool {
        return memsText.text.count + (text.count - range.length) <= 50
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.charCounter.text = String(textView.text.count) + " / 50"
        if let text = self.memsText.text  {
            self.sendButton.isHidden = text.count < 3
        } else {
            self.sendButton.isHidden = true
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isFirstClearText {
            self.memsText.text = ""
            self.charCounter.text = String(self.memsText.text.count) + " / 50"
            self.sendButton.isHidden = true
            isFirstClearText = false
        }
    }
}

