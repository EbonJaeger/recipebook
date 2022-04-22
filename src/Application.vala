public class RecipeBook.Application : Gtk.Application {
    private Database db;

    public Application() {
        Object(application_id: APP_ID, flags: ApplicationFlags.FLAGS_NONE);
    }

    construct {
        this.db = new Database();
    }

    // TODO: For some reason this causes a segfault
    //  protected override void startup() {
    //      this.db = new Database();
    //  }

    protected override void activate() {
        var window = new RecipeBook.View.Window(this);
        window.show();
    }
}
