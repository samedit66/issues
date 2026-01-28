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

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last_oldest(count)
  end

  def do_parse_args([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def do_parse_args([user, project]) do
    {user, project, @default_count}
  end

  # bad arg or --help
  def do_parse_args(_other), do: :help

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from GitHub: #{error["message"]}")
    System.halt(2)
  end

  def sort_into_descending_order(issues_list) do
    issues_list
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def last_oldest(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end
end
