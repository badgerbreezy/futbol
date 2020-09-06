require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def test_it_exists
    games = "games"
    teams = "teams"
    game_teams = "game_teams"
    stat_tracker = StatTracker.new(games, teams, game_teams)
  
    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_initializes_with_from_csv
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)


    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_inherit_csv_data
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    stat_tracker = StatTracker.from_csv(locations)

    assert_instance_of CSV::Table, stat_tracker.games
    assert_instance_of CSV::Table, stat_tracker.teams
    assert_instance_of CSV::Table, stat_tracker.game_teams
  end
end
