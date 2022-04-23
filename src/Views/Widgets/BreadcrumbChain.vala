namespace RecipeBook.View.Widgets {
    /**
     * This class represents a breadcrumb trail for navigation
     * within the app.
     */
    public class BreadcrumbChain : Gtk.Box {
        private GLib.List<Breadcrumb> crumbs;

        /**
         * Emitted when a breadcrumb element has been clicked,
         * with the element's view's `id`.
         */
        public signal void element_clicked(string id);

        /**
         * Creates a new breadcrumb chain widget.
         */
        public BreadcrumbChain() {
            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);
        }

        construct {
            crumbs = new GLib.List<Breadcrumb>();
        }

        /**
         * Append a new breadcrumb to the trail from the given `AbstractView`.
         */
        public new void append(AbstractView view) {
            foreach (var crumb in this.crumbs) {
                crumb.dim();
            }

            var breadcrumb = new Breadcrumb(view);
            breadcrumb.clicked.connect(() => {
                // Don't emit a signal for clicking the last element
                // since that's the current view being displayed.
                if (this.crumbs.last().data == breadcrumb) {
                    return;
                }

                // Go back until we're at the element that was clicked
                while(go_previous() != breadcrumb.view.id) {}

                // Emit our signal to update the view
                this.element_clicked(view.id);
            });

            // Append a separator if there are previous elements
            if (this.crumbs.length() > 0) {
                var sep = new Gtk.Label("/");
                sep.get_style_context().add_class("dim-label");
                base.append(sep);
            }

            base.append(breadcrumb);
            this.crumbs.append(breadcrumb);
        }

        /**
         * Go back one crumb in the trail, removing the last element
         * and returning the `id` of the new last element.
         */
        public string go_previous() {
            this.remove_last();

            var last = this.crumbs.last().data;
            last.undim();
            return last.view.id;
        }

        /**
         * Returns whether or not there is only one breadcrumb in the trail.
         */
        public bool is_at_last() {
            return this.crumbs.length() == 1;
        }

        private void remove_last() {
            base.remove(base.get_last_child());
            base.remove(base.get_last_child()); // Remove the separator which is now last
            this.crumbs.remove(crumbs.last().data);
        }
    }
}
