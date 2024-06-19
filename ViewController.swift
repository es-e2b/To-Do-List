import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todos = [Todo]() {
        didSet {
            saveTodos()
        }
    }
    
    let tableView = UITableView()
    let emptyLabel = UILabel()
    let floatingButton = UIButton()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor") ?? .white
        
        // 상단 제목 레이블 설정
        titleLabel.text = "To-Do List"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(named: "titleColor") ?? .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 테이블 뷰 설정
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "tableViewBackgroundColor") ?? .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // 빈 리스트 메시지 설정
        emptyLabel.text = "No To-Do items"
        emptyLabel.textColor = UIColor(named: "emptyLabelColor") ?? .gray
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.italicSystemFont(ofSize: 18)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        
        // 플로팅 버튼 설정
        floatingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        floatingButton.backgroundColor = UIColor(named: "buttonColor") ?? .systemBlue
        floatingButton.tintColor = .white
        floatingButton.layer.cornerRadius = 25
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        floatingButton.layer.shadowRadius = 10
        floatingButton.addTarget(self, action: #selector(addTodoButtonTapped), for: .touchUpInside)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            floatingButton.widthAnchor.constraint(equalToConstant: 50),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        loadTodos()
        updateEmptyState()
    }
    
    @objc func addTodoButtonTapped() {
        let addTodoVC = AddTodoViewController()
        addTodoVC.didAddTodo = { [weak self] todo in
            self?.todos.append(todo)
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
        let navController = UINavigationController(rootViewController: addTodoVC)
        present(navController, animated: true, completion: nil)
    }
    
    func updateEmptyState() {
        if todos.isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: "todos")
        }
    }
    
    func loadTodos() {
        if let savedTodos = UserDefaults.standard.data(forKey: "todos"),
           let decoded = try? JSONDecoder().decode([Todo].self, from: savedTodos) {
            todos = decoded
        }
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todos[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.textLabel?.text = "\(todo.title) - \(dateFormatter.string(from: todo.date))"
        cell.accessoryType = todo.isCompleted ? .checkmark : .none
        
        // 셀 디자인
        cell.backgroundColor = UIColor(named: "cellBackgroundColor") ?? .white
        cell.textLabel?.textColor = UIColor(named: "cellTextColor") ?? .black
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todos[indexPath.row].isCompleted.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateEmptyState()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editTodo(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor(named: "editActionColor") ?? .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteTodo(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(named: "deleteActionColor") ?? .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func editTodo(at indexPath: IndexPath) {
        // EditTodoViewController를 코드로 초기화
        let editTodoVC = EditTodoViewController()
        
        // 선택된 Todo를 EditTodoViewController에 전달
        editTodoVC.todo = todos[indexPath.row]
        
        // 수정 완료 후 처리할 클로저 설정
        editTodoVC.didUpdateTodo = { [weak self] updatedTodo in
            guard let self = self else { return }
            
            // 업데이트된 Todo를 배열에 반영
            self.todos[indexPath.row] = updatedTodo
            
            // 테이블 뷰의 해당 셀을 리로드하여 변경사항을 반영
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            // 변경된 데이터 저장
            self.saveTodos()
        }
        let navController = UINavigationController(rootViewController: editTodoVC)
        present(navController, animated: true, completion: nil)
    }

    
    func deleteTodo(at indexPath: IndexPath) {
        todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        updateEmptyState()
    }
}
