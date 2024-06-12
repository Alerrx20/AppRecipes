import Foundation
import RealmSwift

class Recipe: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var instructions: String
    @Persisted var ingredients: List<String>
    @Persisted var owner_id: ObjectId
    @Persisted var image: Data
    
    //backlink
    @Persisted(originProperty: "recipes") var group: LinkingObjects<Recipes>

    convenience init(name: String, instructions: String, ingredients: [String], owner_id: ObjectId, image: Data) {
        self.init()
        self._id = ObjectId.generate()
        self.name = name
        self.instructions = instructions
        self.ingredients.append(objectsIn: ingredients)
        self.owner_id = owner_id
        self.image = image
    }

    var bson: Document {
        var document: Document = [
            "_id": AnyBSON(self._id),
            "owner_id": AnyBSON(self.owner_id),
            "name": AnyBSON(self.name),
            "instructions": AnyBSON(self.instructions),
            "ingredients": AnyBSON(self.ingredients.map { AnyBSON($0) })
        ]
        return document
    }
}
