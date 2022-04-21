recipebook_sources = [
    'Application.vala',
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
