namespace RecipeBook.View {
    /**
     * This class holds the view showing the different categories
     * of recipes. It uses a FlowBox to hold the category buttons.
     */
    public class Categories : AbstractView {
        private Gtk.FlowBox flow_box;

        private RecipeBook.Database db;
        private ListStore model;

        public signal void button_clicked(Category category);

        /**
         * Creates a new categories view.
         */
        public Categories(Window parent_window) {
            base(parent_window, "categories", "Categories");

            this.db = Database.@get();
            this.model = new ListStore(typeof(Category));

            try {
                this.db.rebuild_categories(model);
                this.model.sort(compare_categories);
                this.flow_box.bind_model(model, create_new_button);
            } catch (IOError e) {
                critical("Error building categories: %s", e.message);
            }
        }

        protected override void build_view() {
            // Put everything in a scrolled window
            var scrolled_window = new Gtk.ScrolledWindow() {
                hscrollbar_policy = Gtk.PolicyType.NEVER,
                max_content_height = 704,
                min_content_height = 704
            };

            // Create the FlowBox for the category buttons
            this.flow_box = new Gtk.FlowBox() {
                orientation = Gtk.Orientation.HORIZONTAL,
                selection_mode = Gtk.SelectionMode.NONE,
                column_spacing = 32,
                row_spacing = 32,
                margin_start = 32,
                margin_end = 32,
                valign = Gtk.Align.START
            };
            scrolled_window.set_child(flow_box);

            this.append(scrolled_window);
        }

        protected override void connect_signals() {
        }

        /**
         * Create's a new widget for our FlowBox from a Category.
         *
         * The method signature is generic to avoid having to cast
         * the function when passing it to `bind_model` on the
         * FlowBox as doing that causes `this` to be passed here
         * instead of the data from the model.
         */
        private Gtk.Widget create_new_button(Object data) {
            assert(data is Category);

            var category = (Category) data;
            var button = new Widgets.CategoryButton(category);
            button.clicked.connect(() => {
                this.button_clicked(button.category);
            });
            return button;
        }

        /**
         * Sort categories by ID.
         *
         * This always puts the add category button last, with the
         * unorganized category before it. All other categories are
         * sorted alphabetically.
         */
        private int compare_categories(Object a, Object b) {
            assert(a is Category);
            assert(b is Category);

            var cat_a = (Category) a;
            var cat_b = (Category) b;

            if (cat_a.id == "unorganized") {
                // Unorganized category should always be second to last
                if (cat_b.id == "add-category") {
                    return -1;
                } else {
                    return 1;
                }
            } else if (cat_a.id == "add-category") {
                return 1; // Add category button should always be last
            } else {
                return cat_a.id.collate(cat_b.id); // Any other categories, go alphabetically
            }
        }
    }
}
