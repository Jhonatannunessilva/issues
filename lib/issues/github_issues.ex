defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  # use a module attribute to fetch the value at compile time
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    {
      check_for_error(status_code),
      Poison.Parser.parse!(body, %{})
    }
  end

  defp check_for_error(200), do: :ok

  defp check_for_error(_), do: :error
end
