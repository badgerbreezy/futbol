require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require 'Pry'
require './lib/game_team'
require './lib/game_team_manager'

class GameTeamManagerTest < MiniTest::Test
  def setup
    game_team_path = './data/game_teams_dummy.csv'
    @game_team_manager = GameTeamManager.new(game_team_path, "tracker")
  end
  def test_it_exists
    assert_instance_of GameTeamManager, @game_team_manager
  end

  def test_create_underscore_game_teams
    @game_team_manager.game_teams.each do |game_team|
      assert_instance_of GameTeam, game_team
    end
  end

  def test_it_can_find_average_win_percentage
    assert_equal 0.88, @game_team_manager.average_win_percentage("6")
  end

  def test_it_can_get_team_with_best_offense
    @game_team_manager.tracker.stubs(:get_team_name).returns("Real Salt Lake")
    assert_equal "Real Salt Lake", @game_team_manager.best_offense
  end

  def test_it_can_get_team_with_worst_offense
    @game_team_manager.tracker.stubs(:get_team_name).returns("Atlanta United")
    assert_equal "Atlanta United", @game_team_manager.worst_offense
  end

  def test_can_find_most_accurate_team
    @game_team_manager.tracker.stubs(:get_season_game_ids).returns(["2016030171", "2016030172", "2016030173", "2016030174"])
    @game_team_manager.tracker.stubs(:get_team_name).returns("Real Salt Lake")
    assert_equal "Real Salt Lake", @game_team_manager.most_accurate_team("20162017")
  end

  def test_can_find_least_accurate_team
    @game_team_manager.tracker.stubs(:get_season_game_ids).returns(["2016030171", "2016030172", "2016030173", "2016030174"])
    @game_team_manager.tracker.stubs(:get_team_name).returns("Toronto FC")
    assert_equal "Toronto FC", @game_team_manager.least_accurate_team("20162017")
  end

  def test_can_find_team_with_most_tackles
    @game_team_manager.tracker.stubs(:get_season_game_ids).returns(["2016030171", "2016030172", "2016030173", "2016030174"])
    @game_team_manager.tracker.stubs(:get_team_name).returns("Toronto FC")
    assert_equal "Toronto FC", @game_team_manager.most_tackles("20162017")
  end

  def test_can_find_team_with_fewest_tackles
    @game_team_manager.tracker.stubs(:get_season_game_ids).returns(["2016030171", "2016030172", "2016030173", "2016030174"])
    @game_team_manager.tracker.stubs(:get_team_name).returns("Real Salt Lake")
    assert_equal "Real Salt Lake", @game_team_manager.fewest_tackles("20162017")
  end

  def test_can_find_winningest_coach
    game_ids = ["2012020225", "2012020577", "2012020510", "2012020511", "2012030223", "2012030224", "2012030225", "2012030311", "2012030312", "2012030313", "2012030314"]
    assert_equal "Bruce Boudreau", @game_team_manager.find_winningest_coach(game_ids)
  end

  def test_can_find_worst_coach
    game_ids = ["2016030171", "2016030172", "2016030173", "2016030174"]
    assert_equal "Glen Gulutzan", @game_team_manager.find_worst_coach(game_ids)
  end

  def test_it_can_find_all_games
    @game_team_manager.find_all_games("24").each do |game|
      assert_instance_of GameTeam, game
    end
    assert_equal 5, @game_team_manager.find_all_games("24").length
  end

  def test_it_can_find_most_goals_scored
    assert_equal 4, @game_team_manager.most_goals_scored("6")
  end

  def test_it_can_find_fewest_goals_scored
    assert_equal 0, @game_team_manager.fewest_goals_scored("5")
  end

  def test_it_can_find_game_ids
    assert_equal ["2012030221", "2012030222", "2012020577", "2012030224", "2012030311", "2012030312", "2012030313", "2012030314"], @game_team_manager.find_game_ids("6")
  end

  def test_it_has_a_favorite_team_to_beat
    @game_team_manager.tracker.stubs(:get_team_name).returns("Sky Blue FC")
    assert_equal "Sky Blue FC", @game_team_manager.favorite_opponent("6")
  end

  def test_it_has_a_team_it_hates
    @game_team_manager.tracker.stubs(:get_team_name).returns("FC Dallas")
    assert_equal "FC Dallas", @game_team_manager.rival("3")
  end

  def test_game_and_win_count
    game_ids = @game_team_manager.find_game_ids("3")
    expected = @game_team_manager.game_and_win_count(game_ids, :team_id, "WIN", "3")
    expected_array = [{"6" => 3}, {"6" => 3}]

    assert_equal Array, expected.class
    assert_equal Hash, expected[0].class
    assert_equal 2, expected.length
    assert_equal expected_array, expected
  end
  
  def test_sort_accuracy_by_team_id
    @game_team_manager.tracker.stubs(:get_season_game_ids).returns(["2016030171", "2016030172", "2016030173", "2016030174"])
    assert_equal [["20", 7.0], ["24", 12.0]], @game_team_manager.sort_accuracy_by_team_id("20162017")
  end
end
