recipebook_sources = [
    'Application.vala',
    'Views/Categories.vala',
    'Views/NewCategory.vala',
    'Views/Window.vala',
    'Views/Widgets/CategoryButton.vala',
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
