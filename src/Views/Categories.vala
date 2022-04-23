namespace RecipeBook.View {
    public class Categories : Gtk.Box {
        private Gtk.FlowBox flow_box;
        private Widgets.CategoryButton new_category_button;

        public Categories() {
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0
            );
        }

        construct {
            build_view();
        }

        private void build_view() {
            var title = new Gtk.Label("<b>Categories</b>") {
                use_markup = true,
                margin_bottom = 16,
                margin_top = 16
            };
            this.append(title);

            var scrolled_window = new Gtk.ScrolledWindow() {
                hscrollbar_policy = Gtk.PolicyType.NEVER,
                max_content_height = 704,
                min_content_height = 704
            };

            this.flow_box = new Gtk.FlowBox() {
                orientation = Gtk.Orientation.HORIZONTAL,
                selection_mode = Gtk.SelectionMode.NONE,
                column_spacing = 32,
                row_spacing = 32,
                margin_start = 32,
                margin_end = 32,
                valign = Gtk.Align.START
            };
            flow_box.unselect_all();
            scrolled_window.set_child(flow_box);

            var unorganized_button = new Widgets.CategoryButton("unorganized", "Unorganized");
            flow_box.append(unorganized_button);

            this.new_category_button = new Widgets.CategoryButton("add-category", "Add category") {
                image_source = "document-new-symbolic"
            };
            flow_box.append(new_category_button);
            
            this.append(scrolled_window);
        }
    }
}
