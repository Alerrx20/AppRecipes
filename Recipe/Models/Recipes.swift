import Foundation
import RealmSwift

class Recipes: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var recipes = RealmSwift.List<Recipe>()
}
