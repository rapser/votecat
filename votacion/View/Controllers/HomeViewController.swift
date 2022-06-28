//
//  HomeViewController.swift
//  votacion
//
//  Created by miguel tomairo on 26/06/22.
//

import UIKit
import IHProgressHUD

enum Vote: Codable {
    case like
    case deslike
}

class HomeViewController: UIViewController, Storyboarded {
    
    var loading = LoadingView()
    var buttonAllBreeds: UIButton = .iconHeader(named: "icone-perfil")
    var buttonFavorites: UIButton = .iconHeader(named: "icone-logo")
    
    var buttonDeslike: UIButton = .iconFooter(named: "icone-deslike")
    var buttonLike: UIButton = .iconFooter(named: "icone-like")
    
    weak var coordinator: MainCoordinator?
    var breeds: Breeds = []
    let viewModel = HomeViewModel(dataService: DataService())
    var votes: Breeds = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        loading = LoadingView(frame: view.frame)
        view.insertSubview(loading, at: 0)
        wsBreeds()
        addHeaders()
        addFooter()
        getVotes()
    }
    
    private func wsBreeds() {

        viewModel.getListBreeds()
        
        viewModel.updateLoadingStatus = {
            IHProgressHUD.dismiss()
        }

        viewModel.showAlertClosure = { [weak self] in
            if let error = self?.viewModel.error {
                switch error {
                default:
                    Alerts.shared.showSimpleAlert(controller: self!, message: "Error de servicio")
                }
            }
        }
        
        viewModel.didFinish = { [self] arr in
            self.breeds = arr
            self.addCards()
        }
    }
    
    private func getVotes() {
        
        if let arr = UserDefaultsManager.shared.getBreeds() {
            votes = arr
        }
    }
    
    func addPhotoArray(_ photos: Breeds, addedPhoto: Breeds) -> Breeds{
        var resultArray = photos

        for photo in addedPhoto {
            if let photoIndex = resultArray.firstIndex(where: { $0.id == photo.id}) {
                resultArray[photoIndex] = photo
            } else {
                resultArray.append(photo)
            }
        }
        return resultArray
    }
    
    func getDateRegister() -> String {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
}

extension HomeViewController {
    
    func addHeaders() {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let topView: CGFloat = window?.safeAreaInsets.top ?? 44
        
        let stackView = UIStackView(arrangedSubviews: [buttonAllBreeds, buttonFavorites])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.fillView(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: nil,
            padding: .init(top: topView, left: 16, bottom: 0, right: -16)
        )
    }

    func addCards() {
        var index = 0
        
        for var user in breeds {
            let cardView = CombineCardView()
            
            cardView.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: view.bounds.height * 0.7)
            cardView.center = view.center
            
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlerCard))
            
            cardView.addGestureRecognizer(gesture)
            
            user.uuid = index
            cardView.user = user
            cardView.tag = index
            breeds[index].uuid = index
            
            cardView.callback = { (result) in
                self.coordinator?.breedDetail(breed: result)
            }
            
            view.addSubview(cardView)
            
            index += 1
        }
    }
    
    func removeCard(_ card: CombineCardView) {
        card.removeFromSuperview()
        breeds = breeds.filter({ (user) -> Bool in
            return user.uuid != card.tag
        })
    }
    
    @objc func handlerCard(_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view as? CombineCardView {
            let point = gesture.translation(in: view)
            
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationAngle = point.x / view.bounds.width * 0.4
            
            if point.x > 0 {
                card.iconLike.alpha = rotationAngle * 5
                card.iconDeslike.alpha = 0
            } else{
                card.iconDeslike.alpha = (rotationAngle * 5) * -1
                card.iconLike.alpha = 0
            }
            
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            if gesture.state == .ended {
                
                if card.center.x > view.bounds.width + 50 {
                    animateCard(rotationAngle, .like)
                    return
                }
                
                if card.center.x < -50 {
                    animateCard(rotationAngle, .deslike)
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    card.center = self.view.center
                    card.transform = .identity
                    card.iconLike.alpha = 0
                    card.iconDeslike.alpha = 0
                }
            }
        }
    }

    func addFooter() {
        let stackView = UIStackView(arrangedSubviews: [UIView(), buttonDeslike, buttonLike, UIView()])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.fillView(
            top: nil,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor,
            padding: .init(top: 0, left: 16, bottom: -30, right: -16)
        )
        
        addTapButtons()
    }
    
    func addTapButtons() {
        buttonDeslike.addTarget(self, action: #selector(deslike), for: .touchUpInside)
        buttonLike.addTarget(self, action: #selector(like), for: .touchUpInside)
        buttonAllBreeds.addTarget(self, action: #selector(allBreeds), for: .touchUpInside)
        buttonFavorites.addTarget(self, action: #selector(favorite), for: .touchUpInside)
    }
    
    @objc func allBreeds() {
        coordinator?.listBreeds(breeds)
    }
    
    @objc func favorite() {
        
        self.coordinator?.showVotes(votes)
    }
    
    @objc func deslike() {
        animateCard(-0.4, .deslike)
    }
    
    @objc func like() {
        animateCard(-0.4, .like)
    }

    func animateCard(_ rotationAngle: CGFloat, _ action: Vote) {
        if var user = breeds.last {
            for view in self.view.subviews {
                if view.tag == user.uuid {
                    if let card = view as? CombineCardView {
                        let center: CGPoint
                        let viewFrame = self.view.bounds
                        let cardCenterY = card.center.y + 50
                        
                        switch action {
                        case .like:
                            center = CGPoint(x: card.center.x + viewFrame.width, y: cardCenterY)
                            user.vote = .like
                            user.date = getDateRegister()
                            votes.append(user)
                        case .deslike:
                            center = CGPoint(x: card.center.x - viewFrame.width, y: cardCenterY)
                            user.vote = .deslike
                            user.date = getDateRegister()
                            votes.append(user)
                        }
                        self.buttonLike.isEnabled = false
                        self.buttonDeslike.isEnabled = false
                        
                        UIView.animate(withDuration: 0.4) {
                            card.center = center
                            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                        } completion: { _ in
                            self.removeCard(card)
                            self.buttonLike.isEnabled = true
                            self.buttonDeslike.isEnabled = true
                        }
                    }
                }
            }
        }
    }
}
