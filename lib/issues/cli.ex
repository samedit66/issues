defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a table of the last _n_ issues
  in a GitHub project.
  """

  def run(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a GitHub user name, project name and (optionally)
  the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    {_parsed, args, _unknown} =
      OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    do_parse_args(args)
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end

  defp do_parse_args([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  defp do_parse_args([user, project]) do
    {user, project, @default_count}
  end

  # bad arg or --help
  defp do_parse_args(_other), do: :help
end
