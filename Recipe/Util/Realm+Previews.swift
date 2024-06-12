import RealmSwift
import SwiftUI

extension PreviewProvider {
    static func emptyRealmInMemory() -> Realm {
        //configuration for an in-memory Realm
        var conf = Realm.Configuration.defaultConfiguration
        conf.inMemoryIdentifier = "preview"
        
        //create realm
        let realm = try! Realm(configuration: conf)
        return realm
    }
    
    static func realmWithData(realm: Realm = emptyRealmInMemory()) -> Realm {
        let existingRecipes = realm.objects(Recipe.self)
        
        if existingRecipes.count == 0 {
            let recipes = Recipes()
            
            for i in 0...9 {
                recipes.recipes.append(Recipe(name: "Recipe \(i)", instructions: "Instructions \(i)", ingredients: ["Ingredient \(i)", "Ingredient \(i)"], owner_id: ObjectId(), image: Data()))
            }
            
            try? realm.write({
                realm.add(recipes)
            })
        }
        return realm
    }
}
