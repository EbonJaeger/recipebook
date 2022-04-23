namespace RecipeBook.View {
    public class Window : Gtk.ApplicationWindow {
        private Gtk.HeaderBar header;
        private Gtk.Stack pages;

        public Window(RecipeBook.Application app) {
            Object(
                application: app,
                icon_name: "applications-accessories",
                title: APP_TITLE,
                width_request: 720,
                height_request: 644
            );
        }

        construct {
            build_window();
        }

        private void build_window() {
            this.header = new Gtk.HeaderBar() {
                show_title_buttons = true
            };

            this.set_titlebar(header);

            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

            this.pages = new Gtk.Stack();
            var categories_view = new Categories();
            this.pages.add_named(categories_view, "categories");

            box.append(pages);

            this.set_child(box);
        }
    }
}
