namespace RecipeBook.View {
    public class NewCategory : Gtk.Box {

        public NewCategory() {
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0
            );
        }

        construct {
            build_view();
        }

        private void build_view() {
            // Create a title label
            var title = new Gtk.Label("<b>New Category</b>") {
                use_markup = true,
                margin_bottom = 16,
                margin_top = 16
            };
            this.append(title);

            // Make a box to put our form controls in
            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);

            this.append(box);
        }
    }
}
