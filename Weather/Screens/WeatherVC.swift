import UIKit

protocol IWeatherVC: AnyObject {
    
    init(presenter: IWeatherPresenter)
    
    //Update View
    func reloadCollectionView()
}

final class WeatherVC: UIViewController, IWeatherVC {
    
    private var presenter: IWeatherPresenter
    
    private lazy var collectionView: UICollectionView = {
        return createCollectionView()
    }()
    
    private var animateImageView: UIImageView?
    
    init(presenter: IWeatherPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        presenter.viewDidLoad()
        startRandomAnimation()
    }
}

//MARK: - Private methods
extension WeatherVC {
    private func scrollCollectionViewToIndexPath() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let indexPath = self.presenter.getIndexPath()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func startRandomAnimation() {
        presenter.makeRandomWeatherItem()
        collectionView.reloadData()
        
        scrollCollectionViewToIndexPath()
        
        let weather = presenter.getRandomWeatherItem()
        addAnimationImageView(with: weather.image)
    }
}

//MARK: - Update View

extension WeatherVC {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

//MARK: - Layout
extension WeatherVC {
    private func setupViews() {
        view.backgroundColor = Colors.lightBlue
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

//MARK: - UI
extension WeatherVC {
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        
        return collectionView
    }
}

//MARK: - UICollectionViewDataSource
extension WeatherVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.weatherItemsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.configure(with: presenter.getWeatherItem(by: indexPath))
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension WeatherVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.weatherCellSelected(indexPath)
        let weather = presenter.getWeatherItem(by: indexPath)
        
        if let image = UIImage(systemName: weather.image)?.withTintColor(UIColor.systemBlue, renderingMode: .alwaysOriginal) {
            animateImageChange(with: image)
        }
    }
}

//MARK: - Animation
extension WeatherVC {
    private func addAnimationImageView(with imageName: String) {
        animateImageView?.removeFromSuperview()
        
        guard let image = UIImage(systemName: imageName)?.withTintColor(UIColor.systemBlue, renderingMode: .alwaysOriginal)
        else { return }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        imageView.center = view.center
        imageView.alpha = 0.3
        
        view.addSubview(imageView)
        animateImageView = imageView
        
        animateImageView(imageView)
    }
    
    private func animateImageView(_ imageView: UIImageView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.1
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        imageView.layer.add(animation, forKey: "pulsing")
    }
    
    private func animateImageChange(with image: UIImage) {
        guard let imageView = animateImageView else { return }
        
        UIView.transition(
            with: imageView,
            duration: 0.7,
            options: .transitionCrossDissolve,
            animations: {
                imageView.image = image
            },
            completion: nil
        )
    }
}
