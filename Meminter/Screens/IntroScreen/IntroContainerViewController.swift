//
//  FirstViewController.swift
//  pageswift
//
//  Created by Дмитрий on 04/09/2019.
//  Copyright © 2019 Dmitry. All rights reserved.
//

import UIKit

final class IntroContainerViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    private var nextButton: UIButton!
    private var pageControl: UIPageControl!
    private var contentData = [IntroContentModel]()
        
    init() {
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.dataSource = self
        self.delegate = self
        self.createUI()
        self.createLayout()
        self.createContentDataArray()
        
        let startViewController = self.viewControllerAtIndex(index: 0)
        self.setViewControllers([startViewController], direction: .forward, animated: true, completion: nil)
    }
    
    @objc private func nextButtonDidTap(_ sender: UIButton) {
        guard let vc = self.viewControllers?.first as? IntroContentViewController else { return }
        if sender.tag == 0 {
            self.setViewControllers([self.viewControllerAtIndex(index: vc.index + 1)], direction: .forward, animated: true) { [weak self] _ in
                self?.pageControl.currentPage = vc.index + 1
                self?.updateButtonWithIndex(index: vc.index + 1)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateButtonWithIndex(index: Int) {
        switch index {
        case 0, 1:
            self.nextButton.setTitle("ДАЛЕЕ", for: .normal)
            self.nextButton.setTitleColor(.white, for: .normal)
            self.nextButton.tag = 0
        case 2:
            self.nextButton.setTitle("ГОТОВО", for: .normal)
            self.nextButton.setTitleColor(.green, for: .normal)
            self.nextButton.tag = 1
        default:
            break
        }
    }
    
    private func createContentDataArray() {
        let titles = ["Рисуй", "Пиши", "Выбирай"]
        let contents = ["Рисуй прикольные мемасы!", "Пиши веселые шутейки!", "Выбери подходящий текст и рисунок.\nСобери свой мем!"]
        var num = 0
        while num != 3 {
            let page = IntroContentModel(title: titles[num], imageName: "first_\(num + 1)", contentText: contents[num])
            self.contentData.append(page)
            num += 1
        }
    }
    
    private func viewControllerAtIndex(index: Int) -> IntroContentViewController {
        guard self.contentData.indices.contains(index), index >= 0 || index != 3 else { fatalError("ContentViewControllers index out of range") }
        let contentViewController = IntroContentViewController()
        contentViewController.updateView(with: contentData[index])
        contentViewController.index = index
        return contentViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let vc = self.viewControllers?.first as? IntroContentViewController else { return }
        self.pageControl.currentPage = vc.index
        self.updateButtonWithIndex(index: vc.index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? IntroContentViewController, vc.index > 0 else { return nil }
        return self.viewControllerAtIndex(index: vc.index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? IntroContentViewController else { return nil }
        if vc.index == 0 || vc.index == 1 {
            return self.viewControllerAtIndex(index: vc.index + 1)
        }
        return nil
    }
    
    private func createUI() {
        self.pageControl = UIPageControl()
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.currentPageIndicatorTintColor = .green
        self.pageControl.pageIndicatorTintColor = .white
        self.view.addSubview(self.pageControl)
        
        self.nextButton = UIButton(type: .system)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.addTarget(self, action: #selector(nextButtonDidTap(_:)), for: .touchUpInside)
        self.updateButtonWithIndex(index: 0)
        self.view.addSubview(self.nextButton)
    }
    
    private func createLayout() {
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        self.pageControl.widthAnchor.constraint(equalToConstant: self.view.bounds.size.width / 3).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.nextButton.centerYAnchor.constraint(equalTo: self.pageControl.centerYAnchor).isActive = true
        self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.nextButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
