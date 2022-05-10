namespace RecipeBook.View {
    public class CategoryView : AbstractView {
        public Category category { get; construct; }

        private Gtk.ListBox recipes_box;

        private RecipeBook.Database db;

        public signal void recipe_button_clicked(string id, Recipe recipe);

        /**
         * Represents a view for a single Category.
         */
        public CategoryView(Category category) {
            Object(
                category: category,
                id: category.id,
                title: category.name,
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0
            );

            this.db = Database.@get();

            try {
                db.rebuild_recipes(category);
            } catch (IOError e) {
                critical("error getting recipes: %s", e.message);
            }
        }
        
        protected override void build_view() {
            var header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0) {
                halign = Gtk.Align.CENTER,
                hexpand = true,
                margin_bottom = 24
            };

            var description = new Gtk.Label("<big>%s</big>".printf(category.description)) {
                use_markup = true
            };

            header.append(description);

            var scrolled_window = new Gtk.ScrolledWindow() {
                overlay_scrolling = true,
                hscrollbar_policy = Gtk.PolicyType.NEVER,
                vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
                min_content_height = 704,
                propagate_natural_height = true
            };

            this.recipes_box = new Gtk.ListBox() {
                selection_mode = Gtk.SelectionMode.NONE,
                hexpand = true,
                valign = Gtk.Align.START,
                height_request = 704
            };

            var placeholder = new Gtk.Label("<big>No recipes in this category</big>") {
                use_markup = true,
            };
            placeholder.get_style_context().add_class("dim-label");

            var add_recipe_button = new Widgets.RecipeButton("New Recipe", "Add a new recipe to this category.", "list-add-symbolic");
            add_recipe_button.clicked.connect(() => {
                var recipe = new Recipe(category, 0, "", "", "", "", "");
                this.recipe_button_clicked("edit-recipe", recipe);
            });
            this.recipes_box.append(add_recipe_button);

            recipes_box.set_placeholder(placeholder);
            scrolled_window.set_child(recipes_box);
            this.append(header);
            this.append(scrolled_window);
        }

        protected override void connect_signals() {
        }
    }
}
