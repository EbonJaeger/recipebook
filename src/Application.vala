public class RecipeBook.Application : Gtk.Application {
    private Database db;

    construct {
        this.application_id = APP_ID;
        this.flags = ApplicationFlags.FLAGS_NONE;

        this.db = new Database();
    }

    public override void activate() {}
}
