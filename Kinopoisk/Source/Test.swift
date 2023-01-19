////
////  Test.swift
////  Kinopoisk
////
////  Created by Mikhail Bagmet on 19.01.2023.
////
//
//import UIKit
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//    var coordinator: AppCoordinator?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
//        let navigationController = UINavigationController()
//                
//        window = UIWindow(windowScene: windowScene)
//        window?.windowScene = windowScene
//        window?.makeKeyAndVisible()
//        window?.rootViewController = navigationController
//        
//        coordinator = AppCoordinator(navigationController: navigationController)
//        coordinator?.start()
//    }
//}
//
//class AppCoordinator: Coordinator {
//    
//    // MARK: - Properties
//    
//    var navigationController: UINavigationController
//    
//    // MARK: - Initializers
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    // MARK: - Methods
//    
//    func start() {
//        let filmsListCoordinator = FilmsListCoordinator(navigationController: navigationController)
//        coordinate(to: filmsListCoordinator)
//    }
//}
//
//class FilmsListCoordinator: Coordinator, FilmsListFlow {
//    
//    // MARK: - Properties
//    
//    var navigationController: UINavigationController
//    
//    // MARK: - Initializers
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    // MARK: - Methods
//    
//    func start() {
//        let filmsListViewController = FilmsListViewController()
//        let viewModel = FilmsListViewModel()
//        
//        filmsListViewController.coordinator = self
//        filmsListViewController.viewModel = viewModel
//        
//        navigationController.pushViewController(filmsListViewController, animated: true)
//    }
//    
//    func coordinateToFilmDetail(viewModel: FilmDetailViewModelType?) {
//        let filmDetailCoordinator = FilmDetailCoordinator(navigationController: navigationController, viewModel: viewModel)
//        coordinate(to: filmDetailCoordinator)
//    }
//    
//    func coordinateToFilmFilter() {
//        let filmFilterCoordinator = FilmFilterCoordinator(navigationController: navigationController)
//        coordinate(to: filmFilterCoordinator)
//    }
//}
//
//class FilmFilterCoordinator: Coordinator {
//    
//    // MARK: - Properties
//    
//    var navigationController: UINavigationController
//    
//    // MARK: - Initializers
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    // MARK: - Methods
//    
//    func start() {
//        let filterViewController = FilmsFilterViewController()
//        let viewModel = FilmsFilterViewModel()
//        
//        filterViewController.coordinator = self
//        filterViewController.viewModel = viewModel
//        
//        filterViewController.modalPresentationStyle = .popover
//        if let popover = filterViewController.popoverPresentationController {
//            let sheet = popover.adaptiveSheetPresentationController
//            sheet.detents = [.medium(), .large()]
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheet.prefersGrabberVisible = true
//        }
//
//        navigationController.present(filterViewController, animated: true, completion: nil)
//    }
//}
//
//class FilmsListViewController: UIViewController {
//    
//    // MARK: - Properties
//    
//    var coordinator: FilmsListFlow?
//    var viewModel: FilmsListViewModelType?
//    
//    // MARK: - Views
//    
//    private lazy var searchController = FilmsSearchViewController(viewModelDelegate: viewModel as? FilmsSearchViewModelDelegate,
//                                                                  errorHandlingDelegate: self)
//    
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // MARK: ViewModel configuration
//        viewModel?.fetchMovies(page: nil) { [weak self] in
//            DispatchQueue.main.async {
//                self?.bindViewModel()
//                self?.viewModel?.isLoading = false
//            }
//        }
//
//        // MARK: Search setup
//        setupSearch()
//    }
//}
//
//// MARK: - Binding
//extension FilmsListViewController {
//    private func bindViewModel() {
//        viewModel?.films.bind(listener: { films in
//            DispatchQueue.main.async {
//                self.filmsTableView.reloadData()
//            }
//        })
//    }
//}
//
//// MARK: - Search
//
//extension FilmsListViewController {
//    private func setupSearch() {
//        navigationItem.searchController = searchController
//        searchController.searchBar.delegate = searchController
//    }
//}
//
//// MARK: - User Actions
//
//extension FilmsListViewController {
//    @objc func presentFilter() {
//        coordinator?.coordinateToFilmFilter()
//    }
//}
//
//class FilmsSearchViewController: UISearchController {
//    
//    // MARK: - Properties
//    
//    var viewModel: FilmsSearchViewModelType?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    // MARK: - Init
//    
//    init(viewModelDelegate: FilmsSearchViewModelDelegate?, errorHandlingDelegate: FilmsErrorHandlingDelegate?) {
//        super.init(searchResultsController: nil)
//        
//        // MARK: ViewModel configuration
//        viewModel = FilmsSearchViewModel()
//        viewModel?.delegate = viewModelDelegate
//        viewModel?.errorHandlingDelegate = errorHandlingDelegate
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Private Methods
//    private func getFilmsFromSearchResult(filmName: String) {
//        viewModel?.fetchMovies(filmName: filmName, completion: {
//            self.viewModel?.updateFilmsListModel()
//        })
//    }
//}
//
//class FilmsFilterViewController: UIViewController {
//    
//    // MARK: - Properties
//    
//    var coordinator: Coordinator?
//    var viewModel: FilmsFilterViewModelType?
//
//    // MARK: - Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    private lazy var filterTableView = UITableView(frame: view.bounds, style: UITableView.Style.grouped)
//}
//
//// MARK: - Data source, cell model
//
//extension FilmsFilterViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return viewModel?.setSectionName()
//    }
//}
//
//class FilmsListViewModel: FilmsListViewModelType {
//    
//    // MARK: - Delegate
//    
//    weak var errorHandlingDelegate: FilmsErrorHandlingDelegate?
//    
//    // MARK: - Properties
//    
//    var model: [Film]?
//    var films: Box<[Film]?> = Box(nil)
//    
//    var isLoading = false
//    
//    private var selectedIndexPath: IndexPath?
//    private let networkManager = NetworkManager()
//    private var isSearching = false
//    private var currentPage: Int?
//    private var totalPages: Int?
//    
//    var selectedFilmTypes: [Film.FilmType] = []
//    
//    // MARK: - Initializers
//    
//    init() {
//        networkManager.delegate = self
//    }
//    
//    // MARK: - Methods
//    
//    func fetchMovies(page: Int? = nil, completion: @escaping() -> ()) {
//        networkManager.fetchData(page: page) { [weak self] movies, page, totalPages in
//            if self?.model != nil {
//                self?.model?.append(contentsOf: movies)
//            } else {
//                self?.model = movies
//            }
//            self?.films.value = self?.model
//            self?.currentPage = page
//            self?.totalPages = totalPages
//            completion()
//        }
//    }
//    
//    func numberOfRows() -> Int {
//        return films.value?.count ?? 0
//    }
//    
//    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmsTableViewCellViewModelType? {
//        guard let film = films.value?[indexPath.row] else { return nil }
//        
//        checkIfEndOfPage(indexPath: indexPath)
//        
//        return FilmsTableViewCellViewModel(film: film)
//    }
//    
//    func makeDetailViewModel() -> FilmDetailViewModelType? {
//        guard let selectedIndexPath = selectedIndexPath else { return nil }
//        let filmID = films.value?[selectedIndexPath.row].id
//
//        return FilmDetailViewModel(filmID: filmID)
//    }
//    
//    func selectRow(atIndexPath indexPath: IndexPath) {
//        self.selectedIndexPath = indexPath
//    }
//    
//    // MARK: - Private Methods
//    
//    private func checkIfEndOfPage(indexPath: IndexPath) {
//        if indexPath.row == (films.value?.count ?? 0) - Metric.rowsBeloreFetch {
//            if !isSearching {
//                loadNextPage()
//            }
//        }
//    }
//    
//    private func loadNextPage() {
//        guard let currentPage = currentPage, let totalPages = totalPages else { return }
//        
//        if currentPage < totalPages && !isLoading {
//            isLoading = true
//            fetchMovies(page: currentPage + 1) {
//                self.isLoading = false
//            }
//        }
//    }
//}
//
//// MARK: - FilmsSearchViewModel Delegate
//
//extension FilmsListViewModel: FilmsSearchViewModelDelegate {
//    func updateModel(with searchResults: [Film]?) {
//        films.value = searchResults
//        isSearching = true
//    }
//    
//    func resetModel() {
//        films.value = model
//        isSearching = false
//    }
//}
//
//// MARK: - NetworkManagerErrorHandlerDelegate
//
//extension FilmsListViewModel: NetworkManagerErrorHandlerDelegate {
//    func handleErrorMessage(message: String?) {
//        errorHandlingDelegate?.showAlert(message: message)
//    }
//}
//
//class FilmsSearchViewModel: FilmsSearchViewModelType {
//    
//    // MARK: - Delegate
//    
//    weak var errorHandlingDelegate: FilmsErrorHandlingDelegate?
//    weak var delegate: FilmsSearchViewModelDelegate?
//    
//    // MARK: - Properties
//
//    var model: [Film]?
//
//    private let networkManager = NetworkManager()
//    
//    // MARK: - Initializers
//    
//    init() {
//        networkManager.delegate = self
//    }
//
//    // MARK: - Methods
//
//    func fetchMovies(filmName: String?, completion: @escaping() -> ()) {
//        networkManager.fetchData(filmName: filmName) { [weak self] movies, page, totalPages  in
//            self?.model = movies
//            completion()
//        }
//    }
//    
//    func updateFilmsListModel() {
//        delegate?.updateModel(with: model)
//    }
//    
//    func getFilmsListFromModel() {
//        delegate?.resetModel()
//    }
//}
//
//// MARK: - NetworkManagerErrorHandlerDelegate
//
//extension FilmsSearchViewModel: NetworkManagerErrorHandlerDelegate {
//    func handleErrorMessage(message: String?) {
//        errorHandlingDelegate?.showAlert(message: message)
//    }
//}
//
//class FilmsFilterViewModel: FilmsFilterViewModelType {
//
//    // MARK: - Properties
//    
//    var filmType: [Film.FilmType: String]?
//    var selectedFilmTypes: [Film.FilmType] = []
//    
//    private var keys: [Film.FilmType]?
//    private var selectedIndexPath: IndexPath?
//    
//    // MARK: - Initializers
//    
//    init() {
//        self.filmType = generateFilterData()
//        self.keys = filmType?.keys.sorted()
//        print("FilmsFilterViewModel initialzed")
//    }
//    
//    // MARK: - Methods
//    
//    func numberOfRows() -> Int {
//        return filmType?.values.count ?? 0
//    }
//    
//    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmTypeFilterTableViewCellViewModelType? {
//        guard let type = keys?[indexPath.row] else { return nil }
//
//        let isSelected = selectedFilmTypes.contains(type) ? true : false
//
//        print("Make model for cell \(type), \(isSelected)")
//        
//        return FilmTypeFilterTableViewCellViewModel(filmTypeCase: type, isSelected: isSelected)
//    }
//    
//    func selectRow(atIndexPath indexPath: IndexPath) {
//        self.selectedIndexPath = indexPath
//    }
//    
//    func selectOptions(completion: @escaping () -> ()) {
//        guard let selectedIndexPath = selectedIndexPath,
//              let option = keys?[selectedIndexPath.row]
//        else { return }
//
//        if !selectedFilmTypes.contains(option) {
//            selectedFilmTypes.append(option)
//        } else if let index = selectedFilmTypes.firstIndex(of: option) {
//            selectedFilmTypes.remove(at: index)
//        }
//        
//        print(selectedFilmTypes)
//        completion()
//    }
//    
//    func setSectionName() -> String? {
//        return Film.FilmType.localizedTitle
//    }
//    
//    // MARK: - Private Methods
//    
//    private func generateFilterData() -> [Film.FilmType: String] {
//        var data: [Film.FilmType: String] = [:]
//        for option in Film.FilmType.allCases {
//            data[option] = option.displayValue
//        }
//        return data
//    }
//}
