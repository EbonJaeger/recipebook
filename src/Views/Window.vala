namespace RecipeBook.View {
    public class Window : Gtk.ApplicationWindow {
        private Gtk.HeaderBar header;
        private Gtk.Button go_back_button;
        private Gtk.Stack pages;

        private Categories categories_view;

        private string previous_view = "";

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
            connect_signals();
        }

        private void build_window() {
            this.header = new Gtk.HeaderBar() {
                show_title_buttons = true
            };

            this.go_back_button = new Gtk.Button() {
                icon_name = "go-previous-symbolic",
                sensitive = false
            };
            this.go_back_button.set_tooltip_text("Go back");
            this.header.pack_start(go_back_button);

            this.set_titlebar(header);

            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

            this.pages = new Gtk.Stack() {
                transition_duration = 250,
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT
            };

            this.categories_view = new Categories();
            var new_category_view = new NewCategory();

            this.pages.add_named(categories_view, "categories");
            this.pages.add_named(new_category_view, "add-category");

            box.append(pages);

            this.set_child(box);
        }

        private void connect_signals() {
            this.go_back_button.clicked.connect(() => {
                this.pages.set_visible_child_name(previous_view);

                // TODO: This is a temporary hack until I add breadcrumb support
                if (previous_view == "categories") {
                    this.previous_view = "";
                    this.go_back_button.sensitive = false;
                }
            });

            this.categories_view.button_clicked.connect((id) => {
                // TODO: This is a temporary hack until I add breadcrumb support
                this.previous_view = "categories";
                this.go_back_button.sensitive = true;
                this.pages.set_visible_child_name(id);
            });
        }
    }
}
