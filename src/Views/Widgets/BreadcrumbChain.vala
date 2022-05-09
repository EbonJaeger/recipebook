namespace RecipeBook.View.Widgets {
    /**
     * This class represents a breadcrumb trail for navigation
     * within the app.
     */
    public class BreadcrumbChain : Gtk.Box {
        private GLib.Queue<Breadcrumb> prev_crumbs;
        private GLib.Queue<Breadcrumb> forward_crumbs;

        /**
         * Emitted when a breadcrumb element has been clicked, or
         * otherwise gone back along the trail.
         *
         * Has the element's `id` as the paramater.
         */
        public signal void navigation_changed (string id);

        /**
         * Creates a new breadcrumb chain widget.
         */
        public BreadcrumbChain () {
            Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);
        }

        construct {
            prev_crumbs = new GLib.Queue<Breadcrumb> ();
            forward_crumbs = new GLib.Queue<Breadcrumb> ();
        }

        /**
         * Append a new breadcrumb to the trail from the given `AbstractView`.
         */
        public new void append (AbstractView view) {
            var breadcrumb = new Breadcrumb (view);
            breadcrumb.clicked.connect(() => {
                this.go_back_until (breadcrumb.id);
            });

            // Append a separator if there are previous elements
            if (!prev_crumbs.is_empty ()) {
                this.prev_crumbs.peek_tail ().dim ();

                var sep = new Gtk.Label ("/");
                sep.get_style_context ().add_class ("dim-label");
                base.append (sep);
            }

            base.append (breadcrumb);
            this.prev_crumbs.push_tail (breadcrumb);
            this.forward_crumbs.clear ();
        }

        /**
         * Go back along the breadcrumb trail until reaching the
         * given `id`.
         *
         * Emits a signal at the end to update the view.
         */
        public void go_back_until (string id) {
            // Don't emit a signal for clicking the last element
            // since that's the current view being displayed.
            if (prev_crumbs.peek_tail ().id == id) {
                return;
            }

            // Go back until we're at the element
            while (go_previous () != id) {}

            // Emit our signal to update the view
            this.navigation_changed (id);
        }

        /**
         * Go forward in the history once, re-adding the breadcrumb
         * to the display, and returning the `id` of the new last
         * element.
         */
        public string go_forward () {
            this.prev_crumbs.peek_tail ().dim ();

            var item = forward_crumbs.pop_head ();
            this.prev_crumbs.push_tail (item);

            var sep = new Gtk.Label ("/");
            sep.get_style_context ().add_class ("dim-label");
            base.append (sep);
            base.append (item);

            return item.view.id;
        }

        /**
         * Go back one crumb in the trail, removing the last element
         * and returning the `id` of the new last element.
         */
        public string go_previous () {
            var old_last = this.prev_crumbs.pop_tail ();
            this.forward_crumbs.push_head (old_last);

            var last = prev_crumbs.peek_tail ();
            last.undim ();

            this.remove_last ();

            return last.view.id;
        }

        /**
         * Returns whether or not there is only one breadcrumb in the trail.
         */
        public bool is_at_last () {
            return this.prev_crumbs.get_length () == 1;
        }

        /**
         * Returns whether or not there is any forward history stored.
         */
        public bool has_forward_history () {
            return !this.forward_crumbs.is_empty ();
        }

        private void remove_last () {
            base.remove (base.get_last_child ());
            base.remove (base.get_last_child ()); // Remove the separator which is now last
        }
    }
}
