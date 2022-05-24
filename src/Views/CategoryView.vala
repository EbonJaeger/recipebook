namespace RecipeBook.View {
    public class CategoryView : AbstractView {
        public Category category { get; construct; }

        private Gtk.ListBox recipes_box;

        private RecipeBook.Database db;
        private ListStore model;

        public signal void recipe_button_clicked (string id, Recipe recipe);

        /**
         * Represents a view for a single Category.
         */
        public CategoryView (Category category) {
            Object (
                category: category,
                id: category.id,
                title: category.name,
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0
            );

            this.db = Database.@get ();
            this.model = new ListStore (typeof (Recipe));
        }
        
        protected override void build_view () {
            var header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                halign = Gtk.Align.CENTER,
                hexpand = true,
                margin_bottom = 24
            };

            var description = new Gtk.Label ("<big>%s</big>".printf (category.description)) {
                use_markup = true
            };

            header.append (description);

            var scrolled_window = new Gtk.ScrolledWindow () {
                overlay_scrolling = true,
                hscrollbar_policy = Gtk.PolicyType.NEVER,
                vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
                min_content_height = 704,
                propagate_natural_height = true
            };

            this.recipes_box = new Gtk.ListBox () {
                selection_mode = Gtk.SelectionMode.NONE,
                hexpand = true,
                valign = Gtk.Align.START,
                height_request = 704
            };

            var placeholder = new Gtk.Label ("<big>No recipes in this category</big>") {
                use_markup = true,
            };
            placeholder.get_style_context ().add_class ("dim-label");

            recipes_box.set_placeholder (placeholder);
            scrolled_window.set_child (recipes_box);
            this.append (header);
            this.append (scrolled_window);
        }

        protected override void connect_signals () {
        }

        public void refresh () {
            try {
                this.db.get_recipes_for_category (category, model);
                this.model.sort (compare_recipes);
                this.recipes_box.bind_model (model, create_new_recipe_button);
            } catch (IOError e) {
                critical ("error getting recipes: %s", e.message);
            }
        }

        private Gtk.Widget create_new_recipe_button (Object data) {
            assert (data is Recipe);

            var recipe = (Recipe) data;
            var button = new Widgets.RecipeButton (recipe.title, recipe.description, recipe.image_path);
            button.clicked.connect (() => {
                if (recipe.title == "New Recipe") {
                    this.recipe_button_clicked ("edit-recipe", new Recipe (category, -1, "", "", "", "", ""));
                } else {
                    this.recipe_button_clicked (recipe.title, recipe);
                }
            });

            return button;
        }

        private int compare_recipes (Object a, Object b) {
            assert (a is Recipe);
            assert (b is Recipe);

            var recipe_a = (Recipe) a;
            var recipe_b = (Recipe) b;

            if (recipe_a.title == "New Recipe") {
                return 1; // New recipe button should always be last
            } else {
                return recipe_a.title.collate (recipe_b.title);
            }
        }
    }
}
