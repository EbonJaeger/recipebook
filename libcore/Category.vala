namespace RecipeBook {
    /**
     * Represents a category of recipes.
     */
    public class Category : Object {
        /** The `id` of this category. */
        public string id { public get; construct; }
        /** The `name` of this category. */
        public string name { public get; construct; }
        /** The `description` of this category. */
        public string description { public get; construct; }
        /** The `image_path` of this category. */
        public string? image_path { public get; construct; }

        public Category(string id, string name, string description, string? image_path) {
            Object(
                id: id,
                name: name,
                description: description,
                image_path: image_path
            );
        }
    }
}
