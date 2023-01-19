//
//  Test.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 19.01.2023.
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
//class FilmsListCoordinator: Coordinator, FilmsListFlow {
//
//    // MARK: - Properties
//
//    var navigationController: UINavigationController
//    var viewModel: FilmsListViewModelType?
//    var filmsListViewController: FilmsListViewController
//
//    // MARK: - Initializers
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//        self.viewModel = FilmsListViewModel()
//        self.filmsListViewController = FilmsListViewController()
//    }
//
//    // MARK: - Methods
//
//    func start() {
//        filmsListViewController.coordinator = self
//        filmsListViewController.viewModel = viewModel
//        filmsListViewController.searchCoordinator = coordinateToFilmSearch()
//
//        filmsListViewController.navigationItem.searchController = filmsListViewController.searchCoordinator?.searchViewController
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
//
//    // MARK: - Private Methods
//
//    private func coordinateToFilmSearch() -> FilmsSearchCoordinator {
//        let filmsSearchCoordinator = FilmsSearchCoordinator(navigationController: navigationController,
//                                                            viewModelDelegate: viewModel as? FilmsSearchViewModelDelegate,
//                                                            errorHandlingDelegate: filmsListViewController)
//        coordinate(to: filmsSearchCoordinator)
//
//        return filmsSearchCoordinator
//    }
//}
//
//class FilmsSearchCoordinator: Coordinator {
//
//    // MARK: - Properties
//
//    var navigationController: UINavigationController
//    var searchViewController: FilmsSearchViewController
//    var viewModel: FilmsSearchViewModel?
//    var viewModelDelegate: FilmsSearchViewModelDelegate?
//    var errorHandlingDelegate: FilmsErrorHandlingDelegate?
//
//    // MARK: - Initializers
//
//    init(navigationController: UINavigationController, viewModelDelegate: FilmsSearchViewModelDelegate?, errorHandlingDelegate: FilmsErrorHandlingDelegate) {
//        self.navigationController = navigationController
//        self.searchViewController = FilmsSearchViewController()
//        self.viewModelDelegate = viewModelDelegate
//        self.errorHandlingDelegate = errorHandlingDelegate
//    }
//
//    // MARK: - Methods
//
//    func start() {
//        viewModel = FilmsSearchViewModel()
//
//        searchViewController.viewModel = viewModel
//        searchViewController.viewModel?.delegate = viewModelDelegate
//        searchViewController.viewModel?.errorHandlingDelegate = errorHandlingDelegate
//
//        searchViewController.searchBar.delegate = searchViewController
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
//    var searchCoordinator: FilmsSearchCoordinator?
//    var viewModel: FilmsListViewModelType?
//
//    // MARK: - Views
//
//    private lazy var filmsTableView = UITableView(frame: view.bounds, style: UITableView.Style.plain)
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
//class FilmsSearchViewController: UISearchController {
//
//    // MARK: - Properties
//
//    var viewModel: FilmsSearchViewModelType?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    // MARK: - Init
//
//    init(/*viewModelDelegate: FilmsSearchViewModelDelegate?, errorHandlingDelegate: FilmsErrorHandlingDelegate?*/) {
//        super.init(searchResultsController: nil)
//
//        // MARK: Configuration
//        self.searchBar.placeholder = Strings.searchBarPlaceholder
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
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
//    var selectedFilmTypes: [Film.FilmType] = []
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

//class FilmsFilterViewModel: FilmsFilterViewModelType {
//    
//    // MARK: - DataCommunicator
//    
//    var dataCommunicator: DataCommunicator
//    var selectedFilmTypes: [Film.FilmType] = [] {
//        didSet {
//            dataCommunicator.update(data: selectedFilmTypes)
//        }
//    }
//
//    // MARK: - Properties
//    
//    var filmType: [Film.FilmType: String]?
//    //var selectedFilmTypes: [Film.FilmType] = []
//    
//    var selectedFilmTypesChanged: (([Film.FilmType]) -> Void)?
//    
//    private var keys: [Film.FilmType]?
//    private var selectedIndexPath: IndexPath?
//    
//    // MARK: - Initializers
//    
//    init(dataCommunicator: DataCommunicator) {
//        self.dataCommunicator = dataCommunicator
//        self.filmType = generateFilterData()
//        self.keys = filmType?.keys.sorted()
//    }
//}
