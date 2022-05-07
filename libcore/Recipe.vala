namespace RecipeBook {
    public class Recipe : Object {
        public Category category { public get; construct set; }
        public int id { public get; construct set; default = 0; }
        public string title { public get; construct set; default = ""; }
        public string description { public get; construct set; default = ""; }
        public string? image_path { public get; construct set; default = null; }
        public string? prep_time { public get; construct set; default = null; }
        public string? cook_time { public get; construct set; default = null; }

        public Recipe(
            Category category,
            int id,
            string title,
            string description,
            string? image_path,
            string? prep_time,
            string? cook_time
        ) {
            Object(
                category: category,
                id: id,
                title: title,
                description: description,
                image_path: image_path,
                prep_time: prep_time,
                cook_time: cook_time
            );
        }
    }
}
