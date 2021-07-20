import UIKit
import Combine

typealias DataSource = UICollectionViewDiffableDataSource<ViewController.Section, Model>
typealias Snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Model>

class ViewController: UIViewController {
    
    enum Section {
        case springBoard
    }
    
    var viewModel: ViewModel?
    private var dataSource: DataSource!
    private var bag = Set<AnyCancellable>()
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.SpringBoardLayout
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        cv.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        return cv
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupCollectionView()
        setupNavigationBarItems()
        viewModel?.$models
            .sink { [weak self] in self?.updateCollectionViewData(models: $0)}
            .store(in: &bag)
    }
    
    //MARK: - Set Up
    
    private func setupNavigationBarItems() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(add)),
            UIBarButtonItem(title: "Reload all", style: .plain, target: self, action: #selector(reloadAll))
        ]
        title = "Elinext"
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.delegate = self
    }
    
    //MARK: - Intents
    
    @objc private func reloadAll(){
        viewModel?.reloadAll()
    }
    
    @objc private func add(){
        viewModel?.addOne()
    }
}

//MARK: - UICollectionView DataSource

extension ViewController {

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier,
                                                                for: indexPath) as? ImageCell
            else {
                return UICollectionViewCell(frame: .zero)
            }
            cell.configure(with: model)
            return cell
        })
    }

    func updateCollectionViewData(models: [Model]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.springBoard])
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - UICollectionView Delegate

extension ViewController: UICollectionViewDelegate {}

//MARK: - UICollectionViewCompositionalLayout SpringBoard layout

fileprivate extension UICollectionViewCompositionalLayout {
    static var SpringBoardLayout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let spacing = Styles.Default.of(.imageSpacing) / 2
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerGroupSize, subitem: item, count: Styles.SpringBoard.cols.rawValue)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: innerGroup, count: Styles.SpringBoard.rows.rawValue)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
