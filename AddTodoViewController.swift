import UIKit

class AddTodoViewController: UIViewController {
    
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let dateLabel = UILabel()
    let datePicker = UIDatePicker()
    let addButton = UIButton()
    let cancelButton = UIButton() // Cancel Button 추가
    
    var didAddTodo: ((Todo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Title Label
        titleLabel.text = "Add Todo"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Text Field
        titleTextField.placeholder = "Enter title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Date Label
        dateLabel.text = "Select Date and Time:"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Date Picker
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Add Button
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Cancel Button 설정
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .lightGray
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack View
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(cancelButton) // Cancel Button 추가
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.heightAnchor.constraint(equalToConstant: 50) // Cancel Button 높이 제약 추가
        ])
        
        // Automatically select date/time and close picker on selection
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func addButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            displayError(message: "Title cannot be empty.")
            return
        }
        
        let selectedDate = datePicker.date
        let newTodo = Todo(title: title, date: selectedDate, isCompleted: false)
        
        didAddTodo?(newTodo)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil) // 취소 버튼 클릭 시 이전 화면으로 돌아가기
    }
    
    @objc func datePickerValueChanged() {
        // Automatically select date/time and close picker on selection
        titleTextField.resignFirstResponder() // Close keyboard
        
        // Close date picker
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    func displayError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
