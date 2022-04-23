namespace RecipeBook.View {
    /**
     * This class holds the view showing the different categories
     * of recipes. It uses a FlowBox to hold the category buttons.
     */
    public class Categories : AbstractView {
        private Gtk.FlowBox flow_box;
        private Widgets.CategoryButton new_category_button;

        public signal void button_clicked(string id);

        /**
         * Creates a new categories view.
         */
        public Categories() {
            base("categories", "Categories");
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

            // Temporary button for unorganized category.
            // In the future, this should be set up and read from
            // the database.
            var unorganized_button = new Widgets.CategoryButton("unorganized", "Unorganized");
            flow_box.append(unorganized_button);

            // Button to go to the new category page where a user
            // can create a new category.
            this.new_category_button = new Widgets.CategoryButton("new-category", "Add category") {
                image_source = "document-new-symbolic"
            };
            flow_box.append(new_category_button);
            
            this.append(scrolled_window);
        }

        protected override void connect_signals() {
            this.new_category_button.clicked.connect(() => {
                this.button_clicked(new_category_button.id);
            });
        }
    }
}
