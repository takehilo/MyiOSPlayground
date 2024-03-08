import SwiftUI

struct CounterViewWithoutMacro: UIViewControllerRepresentable {
    let model: CounterModelWithoutMacro

    func makeUIViewController(context: Context) -> some UIViewController {
        CounterViewControllerWithoutMacro(model: model)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class CounterModelWithoutMacro {
    @ObservationIgnored private var _count = 0

    var count: Int {
        @storageRestrictions(initializes: _count)
        init(initialValue) {
            _count  = initialValue
        }

        get {
            access(keyPath: \.count )
            return _count
        }

        set {
            withMutation(keyPath: \.count ) {
                _count  = newValue
            }
        }
    }

    @ObservationIgnored private let _$observationRegistrar = Observation.ObservationRegistrar()

    internal nonisolated func access<Member>(
        keyPath: KeyPath<CounterModelWithoutMacro , Member>
    ) {
        _$observationRegistrar.access(self, keyPath: keyPath)
    }

    internal nonisolated func withMutation<Member, MutationResult>(
        keyPath: KeyPath<CounterModelWithoutMacro, Member>,
        _ mutation: () throws -> MutationResult
    ) rethrows -> MutationResult {
        try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
    }

    func incrementButtonTapped() {
        count += 1
    }
}

extension CounterModelWithoutMacro: Observable {}

class CounterViewControllerWithoutMacro: UIViewController {
    let model: CounterModelWithoutMacro

    init(model: CounterModelWithoutMacro) {
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
    CounterViewControllerWithoutMacro(model: CounterModelWithoutMacro())
}

