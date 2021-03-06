require './test/test_helper.rb'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'
    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_exists
    games = 'games'
    teams = 'teams'
    game_teams = 'game_teams'
    stat_tracker = StatTracker.new(@locations)

    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_initializes_with_from_csv
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_it_can_calculate_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_it_can_calculate_percentage_home_wins
    assert_equal 0.53, @stat_tracker.percentage_home_wins
  end

  def test_it_can_calculate_percentage_visitor_wins
    assert_equal 0.41, @stat_tracker.percentage_visitor_wins
  end

  def test_it_can_calculate_percentage_ties
    assert_equal 0.06, @stat_tracker.percentage_ties
  end

  def test_it_can_count_games_by_season
    assert_equal ({ '20132014' => 2, '20122013' => 11, '20162017' => 4 }), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_average_goals_per_game
    assert_equal 4.41, @stat_tracker.average_goals_per_game
  end

  def test_it_can_average_goals_by_season
    assert_equal ({ '20132014' => 4.0, '20122013' => 4.36, '20162017' => 4.75 }), @stat_tracker.average_goals_by_season
  end

  def test_it_can_count_total_number_of_teams
    assert_equal 13, @stat_tracker.count_of_teams
  end

  def test_it_can_get_name_of_team_with_best_offense
    assert_equal 'Real Salt Lake', @stat_tracker.best_offense
  end

  def test_it_can_name_of_team_with_worst_offense
    assert_equal 'Atlanta United', @stat_tracker.worst_offense
  end

  def test_can_find_highest_scoring_visitor
    assert_equal 'FC Cincinnati', @stat_tracker.highest_scoring_visitor
  end

  def test_can_find_highest_scoring_home_team
    assert_equal 'Chicago Fire', @stat_tracker.highest_scoring_home_team
  end

  def test_can_find_lowest_scoring_visitor
    assert_equal 'Atlanta United', @stat_tracker.lowest_scoring_visitor
  end

  def test_can_find_lowest_scoring_home_team
    assert_equal 'Atlanta United', @stat_tracker.lowest_scoring_home_team
  end

  def test_can_find_winningest_coach
    assert_equal 'Bruce Boudreau', @stat_tracker.winningest_coach('20122013')
  end

  def test_can_find_worst_coach
    assert_equal 'Glen Gulutzan', @stat_tracker.worst_coach('20162017')
  end

  def test_can_find_most_accurate_team
    assert_equal 'Real Salt Lake', @stat_tracker.most_accurate_team('20162017')
  end

  def test_can_find_least_accurate_team
    assert_equal 'Toronto FC', @stat_tracker.least_accurate_team('20162017')
  end

  def test_can_find_team_with_most_tackles
    assert_equal 'Toronto FC', @stat_tracker.most_tackles('20162017')
  end

  def test_can_find_team_with_fewest_tackles
    assert_equal 'Real Salt Lake', @stat_tracker.fewest_tackles('20162017')
  end

  def test_it_can_get_team_info
    expected = {
      'team_id' => '24',
      'franchise_id' => '32',
      'team_name' => 'Real Salt Lake',
      'abbreviation' => 'RSL',
      'link' => '/api/v1/teams/24'
    }
    assert_equal expected, @stat_tracker.team_info('24')
  end

  def test_can_get_team_with_best_season
    assert_equal '20132014', @stat_tracker.best_season('24')
  end

  def test_can_get_worst_season_for_team
    assert_equal '20122013', @stat_tracker.worst_season('24')
  end

  def test_it_can_test_for_alltime_winning_pct
    assert_equal 0.88, @stat_tracker.average_win_percentage('6')
  end

  def test_it_can_test_most_goals_scored
    assert_equal 4, @stat_tracker.most_goals_scored('6')
  end

  def test_it_can_test_fewest_goals_scored
    assert_equal 0, @stat_tracker.fewest_goals_scored('5')
  end

  def test_it_has_a_favorite_team_to_beat
    assert_equal 'Sky Blue FC', @stat_tracker.favorite_opponent('6')
  end

  def test_it_has_a_team_it_hates
    assert_equal 'FC Dallas', @stat_tracker.rival('3')
  end
end
