import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        let imageView = UIImageView()

        // Configure imageView
        imageView.image = UIImage(named: "Achievement") // Replace "exampleImage" with your image name
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        _view.addSubview(imageView)

        _view.backgroundColor = UIColor.clear
        let titleLabel = UILabel()
        titleLabel.text = "Congratulation"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center

        let descriptionLabel = UILabel()
        descriptionLabel.text = "You have run total 100m."
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.textAlignment = .center

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.frame = CGRect(x: 0, y: 0, width: _view.frame.width, height: _view.frame.height)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionLabel)
        _view.addSubview(stackView)

    }
}
