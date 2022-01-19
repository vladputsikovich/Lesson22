//
//  ViewController.swift
//  Lesson22
//
//  Created by Владислав Пуцыкович on 15.01.22.
//

import UIKit

fileprivate struct Constants {
    static let searchBarPlaceholder = "Search"
    static let searchBarHeight: CGFloat = 50
    static let advertTopDevide: CGFloat = 8
    static let pageControlHeight: CGFloat = 20
    static let productStackViewDevide: CGFloat = 2.5
    static let countProductOnScreen = 6
    static let countProductRow = 3
}

class ViewController: UIViewController {
    
    private var searchBar = UISearchBar()
    private var advertTopScrollView = UIScrollView()
    private var advertTopStackView = UIStackView()
    private var productScrollView = UIScrollView()
    private var productStackView = UIStackView()
    private var advertBottomScrollView = UIScrollView()
    private var advertBottomStackView = UIStackView()
    private var pageControl = UIPageControl()
    
    private var searchProducts = [Product]()
    
    
    private var menu = Menu()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        createAdvertTopStackView()
        createPageControl()
        createProductStackView()
        createAdvertBottomStackView()
        
        
        fillAdvertTopStackView()
        fillProductStackView()
        fillAdvertBottomStackView()
        
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(keyboardWillShow(_:)),
                    name: UIResponder.keyboardWillShowNotification,
                    object: nil
                )
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(keyboardWillHide(_:)),
                    name: UIResponder.keyboardWillHideNotification,
                    object: nil
                )
    }
    
    func createSearchBar() {
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top ?? .zero
        searchBar = UISearchBar(
            frame: CGRect(
                x: .zero,
                y: topPadding,
                width: view.frame.width,
                height: Constants.searchBarHeight
            )
        )
        searchBar.delegate = self
        searchBar.placeholder = Constants.searchBarPlaceholder
        view.addSubview(searchBar)
    }
    
    func createAdvertTopStackView() {
        advertTopScrollView = UIScrollView(
            frame: CGRect(
                x: .zero,
                y: searchBar.frame.maxY,
                width: view.frame.width,
                height: view.frame.height / Constants.advertTopDevide
            )
        )
        advertTopScrollView.delegate = self
        advertTopScrollView.isPagingEnabled = true
        advertTopScrollView.showsHorizontalScrollIndicator = false
        advertTopScrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(menu.advertsTop.count),
            height: view.frame.height / Constants.advertTopDevide
        )
        advertTopStackView = UIStackView(
            frame: CGRect(
                x: advertTopScrollView.bounds.origin.x,
                y: advertTopScrollView.bounds.origin.y,
                width: view.frame.width,
                height: advertTopScrollView.bounds.height
            )
        )
        view.addSubview(advertTopScrollView)
        advertTopScrollView.addSubview(advertTopStackView)
    }
    
    func createPageControl() {
        pageControl = UIPageControl(
            frame: CGRect(
                x: .zero,
                y: advertTopScrollView.frame.maxY,
                width: view.frame.width,
                height: Constants.pageControlHeight
            )
        )
        pageControl.numberOfPages = menu.advertsTop.count
        pageControl.currentPage = .zero
        pageControl.tintColor = .gray
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        view.addSubview(pageControl)
    }
    
    func createProductStackView() {
        searchProducts = menu.products
        productScrollView = UIScrollView(
            frame: CGRect(
                x: .zero,
                y: pageControl.frame.maxY,
                width: view.frame.width,
                height: view.frame.height - view.frame.height / Constants.productStackViewDevide
            )
        )
        productScrollView.contentSize = CGSize(
            width: view.frame.width,
            height: productScrollView.frame.height * CGFloat((menu.products.count / Constants.countProductOnScreen))
        )
        productStackView = UIStackView(
            frame: CGRect(
                x: productScrollView.bounds.origin.x,
                y: productScrollView.bounds.origin.y,
                width: productScrollView.frame.width,
                height: productScrollView.frame.height * CGFloat((menu.products.count / Constants.countProductOnScreen))
            )
        )
        productStackView.distribution = .fillEqually
        productStackView.axis = .vertical
        productScrollView.showsVerticalScrollIndicator = false
        view.addSubview(productScrollView)
        productScrollView.addSubview(productStackView)
    }
    
    func createAdvertBottomStackView() {
        advertBottomScrollView = UIScrollView(
            frame: CGRect(
                x: .zero,
                y: productScrollView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height - productScrollView.frame.maxY
            )
        )
        advertBottomScrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(menu.advertsBottom.count),
            height: view.frame.height - productScrollView.frame.maxY
        )
        advertBottomStackView = UIStackView(
            frame: CGRect(
                x: advertBottomScrollView.bounds.origin.x,
                y: advertBottomScrollView.bounds.origin.y,
                width: view.frame.width,
                height: advertBottomScrollView.bounds.height
            )
        )
        advertBottomScrollView.isPagingEnabled = true
        advertBottomScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(advertBottomScrollView)
        advertBottomScrollView.addSubview(advertBottomStackView)
    }
    
    func fillAdvertTopStackView() {
        menu.advertsTop.forEach { advert in
            let advertTop = AdvertTopView(frame: advertTopStackView.bounds)
            advertTop.configOf(advert: advert)
            advertTopStackView.addArrangedSubview(advertTop)
        }
    }
    
    func fillProductStackView() {
        productStackView.arrangedSubviews.map { $0.removeFromSuperview() }
        (.zero..<(searchProducts.count / Constants.countProductRow)).forEach { number in
            let horisontal = UIStackView()
            (.zero...(Constants.countProductRow - 1)).forEach { i in
                let productView = ProductView(
                    frame: CGRect(
                        x: .zero,
                        y: .zero,
                        width: productStackView.frame.width / CGFloat(Constants.countProductRow),
                        height: productStackView.frame.width / CGFloat((Constants.countProductOnScreen / Constants.countProductRow))
                    )
                )
                productView.configOf(product: searchProducts[number * Constants.countProductRow + i])
                horisontal.distribution = .fillEqually
                horisontal.addArrangedSubview(productView)
            }
            productStackView.addArrangedSubview(horisontal)
        }
    }
    
    func fillAdvertBottomStackView() {
        menu.advertsBottom.forEach { advert in
            let advertBot = AdvertBottomView(frame: advertTopStackView.bounds)
            advertBot.configOf(advert: advert)
            advertBottomStackView.addArrangedSubview(advertBot)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if round(productScrollView.frame.origin.y) == round(pageControl.frame.maxY) {
                productScrollView.frame.origin.y = searchBar.frame.maxY + 10
                advertTopScrollView.isHidden = true
                pageControl.isHidden = true
            }
        }

    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if round(productScrollView.frame.origin.y) != round(pageControl.frame.maxY){
                productScrollView.frame.origin.y = pageControl.frame.maxY
                advertTopScrollView.isHidden = false
                pageControl.isHidden = false
            }
        }
    }
}

// MARK: UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(advertTopScrollView.contentOffset.x / advertTopScrollView.frame.size.width)
    }
}

// MARK: UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchProducts = []
        menu.products.forEach { product in
            if product.name.lowercased().contains(searchText.lowercased()) {
                searchProducts.append(product)
            }
        }
        fillProductStackView()
    }
}

