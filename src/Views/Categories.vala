namespace RecipeBook.View {
    /**
     * This class holds the view showing the different categories
     * of recipes. It uses a FlowBox to hold the category buttons.
     */
    public class Categories : AbstractView {
        private Gtk.FlowBox flow_box;

        private RecipeBook.Database db;
        private ListStore model;

        public signal void button_clicked(string id);

        /**
         * Creates a new categories view.
         */
        public Categories() {
            base("categories", "Categories");

            this.db = Database.@get();
            this.model = new ListStore(typeof(Category));

            try {
                this.db.rebuild_categories(model);
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
                this.button_clicked(button.category.id);
            });
            return button;
        }
    }
}
