namespace RecipeBook.View {
    public class NewCategory : AbstractView {

        public NewCategory(Window parent_window) {
            base(parent_window, "add-category", "New Category");
        }

        protected override void build_view() {
            // Make a box to put our form controls in
            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);

            this.append(box);
        }

        protected override void connect_signals() {}
    }
}
