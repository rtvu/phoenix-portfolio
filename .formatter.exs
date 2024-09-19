[
  import_deps: [:phoenix],
  plugins: [TailwindFormatter, Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "local/*.{heex,ex,exs}"
  ]
]
