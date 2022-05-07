recipebook_sources = [
    'Application.vala',
    'Views/AbstractView.vala',
    'Views/Categories.vala',
    'Views/CategoryView.vala',
    'Views/EditRecipe.vala',
    'Views/NewCategory.vala',
    'Views/Window.vala',
    'Views/Widgets/Breadcrumb.vala',
    'Views/Widgets/BreadcrumbChain.vala',
    'Views/Widgets/CategoryButton.vala',
    'Views/Widgets/FormControl.vala',
    'Views/Widgets/FormTextEntry.vala',
    'Views/Widgets/FormTextarea.vala',
    'Views/Widgets/RecipeButton.vala',
    'main.vala'
]

recipebook_deps = [
    common_deps,
    dep_gtk,
    recipebook_core_dep,
    config_dep
]

executable(
    meson.project_name(),
    recipebook_sources,
    dependencies: recipebook_deps,
    install: true,
)
