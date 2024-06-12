import RealmSwift

class RealmManager {
 static let shared = RealmManager()
 private let realm: Realm
private init() {
 realm = try! Realm()
 }
func saveData(json: [String: Any]) {
 try! realm.write {
 realm.create(Recipe.self, value: json, update: .modified)
 }
 }
func fetchData() -> Results<Recipe> {
 return realm.objects(Recipe.self)
 }
}
