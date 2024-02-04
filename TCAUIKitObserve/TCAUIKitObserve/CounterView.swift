import SwiftUI

struct CounterView: UIViewControllerRepresentable {
    let model: CounterModel

    func makeUIViewController(context: Context) -> some UIViewController {
        CounterViewController(model: model)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

@Observable
class CounterModel {
    var count = 0

    func incrementButtonTapped() {
        count += 1
    }
}

class CounterViewController: UIViewController {
    let model: CounterModel

    init(model: CounterModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let incrementButton = UIButton(type: .system)
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        incrementButton.setTitle("+", for: .normal)
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(incrementButton)

        NSLayoutConstraint.activate([
            incrementButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            incrementButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        func track() {
            withObservationTracking {
                _ = self.model.count
            } onChange: {
                Task { @MainActor in
                    print("\(self.model.count)")
                    track()
                }
            }
        }
        track()
    }

    @objc func incrementButtonTapped() {
        model.incrementButtonTapped()
    }
}

#Preview {
    CounterViewController(model: CounterModel())
}
