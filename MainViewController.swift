import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    var mainPageViewController: MainPageViewController? {
        didSet {
            mainPageViewController?.mainDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.addTarget(self, action: #selector(MainViewController.didChangePageControlValue), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainPageViewController = segue.destination as? MainPageViewController {
            self.mainPageViewController = mainPageViewController
        }
    }

    @IBAction func didTapNextButton(_ sender: UIButton) {
        mainPageViewController?.scrollToNextViewController()
    }
    
    func didChangePageControlValue() {
        mainPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}

extension MainViewController: MainPageViewControllerDelegate {
    
    func mainPageViewController(_ mainPageViewController: MainPageViewController,
        didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func mainPageViewController(_ mainPageViewController: MainPageViewController,
        didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
