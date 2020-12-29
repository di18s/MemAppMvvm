import UIKit
import Combine

final class CatalogViewController: UIViewController, LoadableViewInput {
    private var catalogViewModel: CatalogViewModelInput
	private var subscriptions: Set<AnyCancellable> = []
    
    var activityIndicator: UIActivityIndicatorView!
    private var collectionView: UICollectionView!
    private let refreshControl: UIRefreshControl = {
        let myRefresh = UIRefreshControl()
        myRefresh.tintColor = .red
        myRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return myRefresh
    }()
        
    init(catalogViewModel: CatalogViewModelInput) {
        self.catalogViewModel = catalogViewModel
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollection()
        self.createUI()
        
        self.subscrideOnCatalogUpdate()
        self.setLoading(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		self.catalogViewModel.getCatalog(25, desc: true, as: .new)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        self.refreshControl.beginRefreshing()
		self.catalogViewModel.getCatalog(25, desc: true, as: .new)
    }

    private func subscrideOnCatalogUpdate() {
		self.catalogViewModel.currentError
			.sink { [weak self] error in
				guard let strongSelf = self else { return }
				strongSelf.setLoading(false)
				guard let error = error?.error else { return }
				strongSelf.showError(title: "Error", message: error)
				strongSelf.refreshControl.endRefreshing()
			}
			.store(in: &self.subscriptions)
		
		self.catalogViewModel.memCatalogSubject
			.sink { [weak self] memcatalog in
				guard let strongSelf = self else { return }
				strongSelf.setLoading(false)
				guard memcatalog != nil else { return }
				strongSelf.collectionView.reloadData()
				strongSelf.refreshControl.endRefreshing()
			}
			.store(in: &self.subscriptions)
    }
    
    private func setUpCollection() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewLayout)
        self.collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: CatalogCollectionViewCell.cellIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.refreshControl = self.refreshControl
        self.collectionView.backgroundColor = .white
        self.view.addSubview(self.collectionView)
    }
    
    private func createUI() {
        self.view.backgroundColor = .white
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.color = .red
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.center = self.view.center
    }
}

extension CatalogViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard let count = self.catalogViewModel.memCatalogSubject.value?.count, count > 0 else { return }
        if self.collectionView.indexPathsForVisibleItems.contains(IndexPath(item: count - 1, section: 0)) {
            self.setLoading(true)
			self.catalogViewModel.getCatalog(25, desc: true, as: .addition)
        }
    }
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.catalogViewModel.memCatalogSubject.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCollectionViewCell.cellIdentifier, for: indexPath) as? CatalogCollectionViewCell else { fatalError("Wrong cell class") }
        if let catalog = self.catalogViewModel.memCatalogSubject.value?[safe: indexPath.item] {
            cell.configure(catalog)
        }
        return cell
    }
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width / 2 - 7.5, height: (self.view.bounds.width / 2 - 7.5) / 9 * 16 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
