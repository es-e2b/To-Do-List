import UIKit

// Todo 모델
struct Todo : Codable{
    var id = UUID()
    var title: String
    var date: Date
    var isCompleted: Bool
}

// Todo 리스트
var todoList: [Todo] = [
    Todo(title: "Task 1", date: Date(), isCompleted: false),
    Todo(title: "Task 2", date: Date(), isCompleted: true),
    Todo(title: "Task 3", date: Date(), isCompleted: false)
]
