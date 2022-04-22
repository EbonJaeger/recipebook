namespace RecipeBook.View {
    public class Window : Gtk.ApplicationWindow {
        private Gtk.HeaderBar header;

        public Window(RecipeBook.Application app) {
            Object(
                application: app,
                icon_name: "applications-accessories",
                title: APP_TITLE,
                width_request: 500,
                height_request: 300
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

            this.set_child(box);
        }
    }
}
