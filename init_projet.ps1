# Créer les dossiers
New-Item -ItemType Directory -Path "config"
New-Item -ItemType Directory -Path "lib/my_app" -Force
New-Item -ItemType Directory -Path "test"

# Créer les fichiers de configuration
@'
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 98
]
'@ | Out-File -FilePath ".formatter.exs" -Encoding utf8

@'
# The directory Mix will write compiled artifacts to
/_build/

# If you run "mix test --cover", coverage assets end up here
/cover/

# The directory Mix downloads your dependencies sources to
/deps/

# Where third-party dependencies like ExDoc output generated docs
/doc/

# Ignore .fetch files in case you like to edit your project deps locally
/.fetch

# If the VM crashes, it generates a dump, let's ignore it too
erl_crash.dump

# Also ignore archive artifacts (built via "mix archive.build")
*.ez

# Temporary files
/tmp/

# Environment variables
.env
'@ | Out-File -FilePath ".gitignore" -Encoding utf8

@'
defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {MyApp.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end
end
'@ | Out-File -FilePath "mix.exs" -Encoding utf8

@'
import Config

config :my_app,
  environment: config_env()

import_config "#{config_env()}.exs"
'@ | Out-File -FilePath "config/config.exs" -Encoding utf8

@'
import Config

config :my_app,
  debug_mode: true
'@ | Out-File -FilePath "config/dev.exs" -Encoding utf8

@'
import Config

config :my_app,
  debug_mode: false
'@ | Out-File -FilePath "config/test.exs" -Encoding utf8

@'
import Config

config :my_app,
  debug_mode: false
'@ | Out-File -FilePath "config/prod.exs" -Encoding utf8

@'
defmodule MyApp.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Ajoutez vos superviseurs et processus ici
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
'@ | Out-File -FilePath "lib/my_app/application.ex" -Encoding utf8

@'
defmodule MyApp do
  @moduledoc """
  Documentation pour MyApp.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MyApp.hello()
      :world

  """
  def hello do
    :world
  end
end
'@ | Out-File -FilePath "lib/my_app.ex" -Encoding utf8

@'
ExUnit.start()
'@ | Out-File -FilePath "test/test_helper.exs" -Encoding utf8

@'
defmodule MyAppTest do
  use ExUnit.Case
  doctest MyApp

  test "greets the world" do
    assert MyApp.hello() == :world
  end
end
'@ | Out-File -FilePath "test/my_app_test.exs" -Encoding utf8