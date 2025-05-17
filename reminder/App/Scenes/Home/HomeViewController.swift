//
//  HomeViewController.swift
//  reminder
//
//  Created by Melik on 3.05.2025.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    
}

class HomeViewController : UIViewController,
                        HomeViewControllerProtocol {

    private var taskCollectionView : UICollectionView! = nil
    private let cellStackView : UIStackView = UIStackView()
    private let plusImageView = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
    private var dayParam: Date = .now
    private var dailyTasks : [DailyTask] = []

    private var viewModel: HomeViewModelProtocol
    private var onNavigateTaskView: ((DailyTask?) -> Void)
    
    var sections: [HomeSectionType] {
        let result: [HomeSectionType] = [
            .date,
            .welcome,
            .title,
            .tasks(filterTaskByDate())
        ]
        return result
    }
    
    init(homeViewModel: HomeViewModelProtocol , onNavigateTaskView: @escaping (DailyTask?) -> Void) {
        self.viewModel = homeViewModel
        self.onNavigateTaskView = onNavigateTaskView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        loadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = taskCollectionView.cellForItem(at: indexPath) as? CalendarCell {
            cell.refreshManually()
        }
    }
    
    
    private func filterTaskByDate() -> [DailyTask] {
        return dailyTasks.filter{ self.viewModel.areTheySameDay(date1: $0.remindAt, date2: dayParam) }
    }
    
    private func loadTasks() {
        self.dailyTasks = self.viewModel.getAllTasksByDate(date: dayParam)
    }

}

extension HomeViewController : CalendarCellDelegate,
                               TaskCellDelegate,
                               TaskViewControllerDelegate {
    
    func didClickCalendarCell(date :Date){
        self.dayParam = date
        plusImageView.isHidden = viewModel.isPlusImageHidden(date: date)
        self.loadTasks()
        self.taskCollectionView.reloadData()
    }
    
    func getDisplayedDates(date : Date?) -> [Date] {
        return self.viewModel.getDisplayedDates(date: date)
    }
    
    func didCheckTaskCell(task: DailyTask, newValue: Bool){
        let newTask : DailyTask = DailyTask(id: task.id, title: task.title,remindAt: task.remindAt, completedAt: .now,isCompleted: newValue)
        self.viewModel.updateTask(newTask: newTask)
        self.loadTasks()
        self.taskCollectionView.reloadData()
    }
    
    func onSaveTask() {
        self.loadTasks()
        self.taskCollectionView.reloadData()
    }
}


extension HomeViewController : UICollectionViewDataSource,
                               UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .date:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            cell.configure(delegate: self)
            return cell

        case .welcome:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomingTitleCell", for: indexPath) as! WelcomingTitleCell
            cell.configure(greetingMessage: viewModel.buildGreetingMessage())
            return cell

        case .title:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTitleCell", for: indexPath) as! MainTitleCell
            cell.configure()
            return cell

        case .tasks(let tasks):
            let task = tasks[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! TaskCell
            let completionTime = self.viewModel.setCompletionTime(task: task)
            cell.configure(dailyTask: task, delegate: self,completionTime: completionTime)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .date, .welcome, .title:
            return 1
        case .tasks(let tasks):
            return tasks.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch sections[indexPath.section] {
        case .date:
            return CGSize(width: collectionView.frame.width, height: 40)
        case .welcome:
            return CGSize(width: collectionView.frame.width, height: 60)
        case .title:
            return CGSize(width: collectionView.frame.width, height: 25)
        case .tasks:
            return CGSize(width: collectionView.frame.width, height: 80)
        }
    }
}


private extension HomeViewController {
    func buildViews(){
        view.backgroundColor = .systemBackground
        
        buildTaskCollectionView()
        buildPlusButton()
        buildConstraints()
    }
    
    func buildTaskCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        taskCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        taskCollectionView.backgroundColor = .systemBackground
        taskCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        taskCollectionView.dataSource = self
        taskCollectionView.delegate = self
        taskCollectionView.translatesAutoresizingMaskIntoConstraints = false
        taskCollectionView.showsVerticalScrollIndicator = false
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        taskCollectionView.addGestureRecognizer(longPressGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.isEnabled = true
        swipeGesture.direction = .left
        taskCollectionView.addGestureRecognizer(swipeGesture)
        
        taskCollectionView.register(TaskCell.self, forCellWithReuseIdentifier: "TaskCell")
        taskCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        taskCollectionView.register(WelcomingTitleCell.self , forCellWithReuseIdentifier: "WelcomingTitleCell")
        taskCollectionView.register(MainTitleCell.self, forCellWithReuseIdentifier: "MainTitleCell")
        view.addSubview(taskCollectionView)
    }
    
    func buildPlusButton(){
        
        cellStackView.axis = .horizontal
        cellStackView.alignment = .center
        cellStackView.distribution = .equalSpacing
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cellStackView)
        
        let spacer : UIView = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.addArrangedSubview(spacer)
        
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        plusImageView.tintColor = UIColor.label
        plusImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(plusIconTapped))
        plusImageView.addGestureRecognizer(tapGesture)
        
        cellStackView.addArrangedSubview(plusImageView)
    }
    
    func buildConstraints() {
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(taskCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8))
        constraints.append(taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8))
        constraints.append(taskCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30))
        constraints.append(taskCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10))
        
        constraints.append(plusImageView.widthAnchor.constraint(equalToConstant: 70))
        constraints.append(plusImageView.heightAnchor.constraint(equalToConstant: 70))
        constraints.append(cellStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50))
        constraints.append(cellStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: taskCollectionView)

            if let indexPath = taskCollectionView.indexPathForItem(at: point) {

                let sectionType = sections[indexPath.section]
                
                switch sectionType {
                case .tasks (let tasks):
                    let task = tasks[indexPath.row]
                    if !task.isCompleted {
                        editTask(task: task)
                    }
                default:
                    break
                }
            }
        }
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        let location = gesture.location(in: taskCollectionView)
        
        guard
            let indexPath = taskCollectionView.indexPathForItem(at: location),
            let cell = taskCollectionView.cellForItem(at: indexPath) as? TaskCell,
            let task = cell.task
        else {
            return
        }
            
        showDeleteConfirmation(for: task, at: indexPath)
    }
    
    func showDeleteConfirmation(for task: DailyTask, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "\(task.title) Görevi Silinsin mi?",
            message: "Bu görevi silmek istediğinize emin misiniz?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.viewModel.deleteTask(task: task)
            self.dailyTasks.removeAll { $0.id == task.id }
            self.taskCollectionView.deleteItems(at: [indexPath])
        }
        
        let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    func editTask(task: DailyTask){
        onNavigateTaskView(task)
    }
    
    @objc func plusIconTapped() {
        onNavigateTaskView(nil)
    }

}

#Preview {
    let viewModel : HomeViewModelProtocol = PreviewHomeViewModel()
    HomeViewController(homeViewModel: viewModel,
                       onNavigateTaskView: { task in})
}
 

