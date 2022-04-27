namespace RecipeBook.View {
    public class Window : Gtk.ApplicationWindow {
        private Gtk.HeaderBar header;
        private Gtk.Button go_back_button;
        private Gtk.Button home_button;
        private Gtk.Stack pages;

        private Widgets.BreadcrumbChain breadcrumbs;
        private Categories categories_view;

        public Window(RecipeBook.Application app) {
            Object(
                application: app,
                icon_name: "com.github.EbonJaeger.recipebook",
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
                tooltip_text = "Go back",
                sensitive = false
            };
            this.header.pack_start(go_back_button);

            this.home_button = new Gtk.Button() {
                icon_name = "go-home-symbolic",
                tooltip_text = "Home"
            };
            this.header.pack_start(home_button);

            this.set_titlebar(header);

            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            var subheader = new Gtk.Box(Gtk.Orientation.VERTICAL, 0) {
                margin_bottom = 16
            };
            box.append(subheader);

            this.breadcrumbs = new Widgets.BreadcrumbChain() {
                halign = Gtk.Align.START
            };
            subheader.append(breadcrumbs);

            this.pages = new Gtk.Stack() {
                transition_duration = 250,
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT
            };

            this.categories_view = new Categories();
            this.breadcrumbs.append(categories_view);
            var new_category_view = new NewCategory();

            this.pages.add_named(categories_view, categories_view.id);
            this.pages.add_named(new_category_view, new_category_view.id);

            this.set_title();

            box.append(pages);

            this.set_child(box);
        }

        private void connect_signals() {
            this.go_back_button.clicked.connect(() => {
                this.pages.set_visible_child_name(breadcrumbs.go_previous());
                this.set_title();

                if (breadcrumbs.is_at_last()) {
                    this.go_back_button.sensitive = false;
                }
            });

            this.home_button.clicked.connect(() => {
                this.breadcrumbs.go_back_until(categories_view.id);
            });

            this.breadcrumbs.navigation_changed.connect((id) => {
                this.pages.set_visible_child_name(id);
                this.set_title();

                if (breadcrumbs.is_at_last()) {
                    this.go_back_button.sensitive = false;
                }
            });

            this.categories_view.button_clicked.connect((id) => {
                this.go_back_button.sensitive = true;
                this.pages.set_visible_child_name(id);
                this.set_title();
                this.breadcrumbs.append(pages.get_visible_child() as AbstractView);
            });
        }

        /**
         * Sets the window title based on the current view being shown.
         *
         * If the view is the main categories view, only the base app
         * name will be shown.
         */
        private new void set_title() {
            var current_page = pages.get_visible_child() as AbstractView;
            var new_title = APP_TITLE;

            if (current_page.id != "categories") {
                new_title = APP_TITLE + " - " + current_page.title;
            }

            base.set_title(new_title);
        }
    }
}
