import UIKit

struct RGBColor {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 1.0
    
    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class MenuView: UIView {
    static let MenuViewDrawingParamDidChangedNotification = Notification.Name(rawValue: "MenuViewDrawingParamDidChangedNotification")
    
    @objc dynamic var visible = true
    var rgbColor = RGBColor()
    
    @IBOutlet weak var blackBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var orangeBtn: UIButton!
    @IBOutlet weak var yellowBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var magentaBtn: UIButton!
    @IBOutlet weak var blueBtn: UIButton!
    @IBOutlet weak var cyanBtn: UIButton!
    @IBOutlet weak var grayBtn: UIButton!
    var colorArray = [UIButton]()
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var lineWidthSlider: UISlider!
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(visible))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorArray = [self.blackBtn, self.redBtn, self.orangeBtn, self.yellowBtn, self.greenBtn, self.magentaBtn, self.blueBtn, self.cyanBtn, self.grayBtn]
        colorView.backgroundColor = rgbColor.uiColor
        setupColorView()
        self.lineWidthSlider.addTarget(self, action: #selector(lineWidthCnanging(_:)), for: .valueChanged)
        addObserver(self, forKeyPath: #keyPath(visible), options: .new, context: nil)
    }
    
    // настройка ColorView
    private func setupColorView() {
        lineWidthSlider.value = 6
        colorView.backgroundColor = rgbColor.uiColor
        colorView.transform = CGAffineTransform(scaleX: CGFloat(lineWidthSlider.value/40),
                                                y: CGFloat(lineWidthSlider.value/40))
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 20
    }
    

    //MARK: - color sliders actions
    
    @IBAction func redChanging(_ sender: UISlider) {
        rgbColor.red = CGFloat(sender.value)
        colorView.backgroundColor = rgbColor.uiColor
    }
    @objc func lineWidthCnanging(_ sender: Any) {
        colorView.transform = CGAffineTransform(scaleX: CGFloat(lineWidthSlider.value/40),
                                                y: CGFloat(lineWidthSlider.value/40))
    }
    
    @IBAction func greenChanging(_ sender: UISlider) {
        rgbColor.green = CGFloat(sender.value)
        colorView.backgroundColor = rgbColor.uiColor
    }
    
    @IBAction func blueChanging(_ sender: UISlider) {
        rgbColor.blue = CGFloat(sender.value)
        colorView.backgroundColor = rgbColor.uiColor
    }
    
    @IBAction func alphaChanging(_ sender: UISlider) {
        rgbColor.alpha = CGFloat(sender.value)
        colorView.backgroundColor = rgbColor.uiColor
    }
    
    //MARK: - color buttons actions
    
    @IBAction func blackBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = UIColor.black
        rgbColor.red = 0.0
        rgbColor.green = 0.0
        rgbColor.blue = 0.0
    }
    
    @IBAction func redBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = UIColor.red
        rgbColor.red = 1.0
        rgbColor.green = 0.0
        rgbColor.blue = 0.0
    }
    
    @IBAction func orangeBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = .orange
        rgbColor.red = 1.0
        rgbColor.green = 0.65
        rgbColor.blue = 0.0
    }
    
    @IBAction func yellowBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = UIColor.yellow
        rgbColor.red = 1.0
        rgbColor.green = 1.0
        rgbColor.blue = 0.0
    }
    
    @IBAction func greenBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = UIColor.green
        rgbColor.red = 0.0
        rgbColor.green = 1.0
        rgbColor.blue = 0.0
    }
    
    @IBAction func magentaBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = UIColor.magenta
        rgbColor.red = 1.0
        rgbColor.green = 0.0
        rgbColor.blue = 1.0
    }
    
    @IBAction func blueBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = UIColor.blue
        rgbColor.red = 0.0
        rgbColor.green = 0.0
        rgbColor.blue = 1.0
    }
    
    @IBAction func cyanBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = UIColor.cyan
        rgbColor.red = 0.0
        rgbColor.blue = 1.0
        rgbColor.green = 1.0
    }
    
    @IBAction func lightGrayBtnTap(_ sender: UIButton) {
        for i in self.colorArray {
            i.transform = .identity
        }
        if sender.state == .highlighted {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        colorView.backgroundColor = UIColor.lightGray
        rgbColor.red = 0.83
        rgbColor.blue = 0.83
        rgbColor.green = 0.83
    }
    
    //MARK: - observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(visible) && visible == false {
            let params: [String: Any] = ["lineWidth": lineWidthSlider.value, "color": rgbColor.uiColor]
            NotificationCenter.default.post(name: MenuView.MenuViewDrawingParamDidChangedNotification, object: params)
        }
    }
    
    //MARK: - getting params
    
    func getParamsForDrawing() -> (CGFloat, UIColor) {
        return (CGFloat(lineWidthSlider.value), rgbColor.uiColor)
    }
}
