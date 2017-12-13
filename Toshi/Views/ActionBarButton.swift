import UIKit

class ActionBarButton: UIControl {
    let imageView = UIImageView(withAutoLayout: true)
    
    let titleLabel = UILabel(withAutoLayout: true)
    
    private let imageContainerView = UIView(withAutoLayout: true)
    
    private var previousLabelTintColor: UIColor?
    private var previousImageTintColor: UIColor?
    
    override var tintColor: UIColor! {
        didSet {
            titleLabel.textColor = tintColor
            imageView.tintColor = tintColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.font = Theme.medium(size: 14)
        
        imageContainerView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        
        imageContainerView.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        
        addSubview(imageContainerView)
        addSubview(titleLabel)
        
        titleLabel.set(height: 16)
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        imageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageContainerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageContainerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageContainerView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
    }
    
    required init?(coder _: NSCoder) {
        fatalError()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        isHighlighted = true
        
        previousImageTintColor = imageView.tintColor
        previousLabelTintColor = titleLabel.tintColor
        
        imageView.tintColor = Theme.tintColor
        titleLabel.textColor = Theme.tintColor
        sendActions(for: .touchDown)
    }
    
    override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        isHighlighted = false
        
        imageView.tintColor = previousImageTintColor
        titleLabel.textColor = previousLabelTintColor
    }
    
    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        isHighlighted = false
        
        imageView.tintColor = previousImageTintColor
        titleLabel.textColor = previousLabelTintColor
        
        sendActions(for: .touchUpInside)
    }
}
