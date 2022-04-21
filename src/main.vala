public static int main(string[] args) {
    Environment.set_application_name(Config.APP_NAME);
    Environment.set_prgname(Config.APP_NAME);

    var application = new RecipeBook.Application();
    return application.run(args);
}
