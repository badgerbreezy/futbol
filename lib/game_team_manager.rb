require 'csv'
require_relative './mathable'

class GameTeamManager
  include Mathable
  attr_reader :game_teams,
              :tracker
  def initialize(path, tracker)
    @game_teams = []
    create_underscore_game_teams(path)
    @tracker = tracker
  end

  def create_underscore_game_teams(path)
    game_teams_data = CSV.read(path, headers: true)
    @game_teams = game_teams_data.map { |data| GameTeam.new(data, self) }
  end

  def average_win_percentage(team_id)
    team_game_count = Hash.new(0)
    team_wins = Hash.new(0)
    @game_teams.each do |game|
      next unless game.team_id == team_id

      team_game_count[game.team_id] += 1
      team_wins[game.team_id] += 1 if game.result == 'WIN'
    end
    (team_wins[team_id].to_f / team_game_count[team_id]).round(2)
  end

  def best_offense
    best_offense_goals = game_and_stat_count(@game_teams, :team_id, :goals)
    best_offense = sort_percentages(best_offense_goals.first, best_offense_goals.last)
    @tracker.get_team_name(best_offense.last[0])
  end

  def worst_offense
    goals_and_games_hashes = game_and_stat_count(@game_teams, :team_id, :goals)
    worst_offense = sort_percentages(goals_and_games_hashes.first, goals_and_games_hashes.last)
    @tracker.get_team_name(worst_offense.first[0])
  end

  def sort_accuracy_by_team_id(season)
    game_ids = @tracker.get_season_game_ids(season)
    total_shots_by_team = Hash.new(0.0)
    total_goals_by_team = Hash.new(0.0)
    @game_teams.each do |game|
      if game_ids.include?(game.game_id)
        total_shots_by_team[game.team_id] += game.shots.to_f
        total_goals_by_team[game.team_id] += game.goals.to_f
      end
    end
    sort_percentages(total_goals_by_team, total_shots_by_team)
  end

  def most_accurate_team(season)
    sort_accuracy_by_team_id(season)
    @tracker.get_team_name(sort_accuracy_by_team_id(season).last[0])
  end

  def least_accurate_team(season)
    sort_accuracy_by_team_id(season)
    @tracker.get_team_name(sort_accuracy_by_team_id(season).first[0])
  end

  def most_tackles(season)
    game_ids = @tracker.get_season_game_ids(season)
    team_tackles = Hash.new(0)
    @game_teams.each do |game|
      team_tackles[game.team_id] += game.tackles.to_i if game_ids.include?(game.game_id)
    end
    most_tackles_team = team_tackles.max_by { |_team, tackles| tackles }
    @tracker.get_team_name(most_tackles_team[0])
  end

  def fewest_tackles(season)
    game_ids = @tracker.get_season_game_ids(season)
    team_tackles = Hash.new(0)
    @game_teams.each do |game|
      team_tackles[game.team_id] += game.tackles.to_i if game_ids.include?(game.game_id)
    end
    most_tackles_team = team_tackles.min_by { |_team, tackles| tackles }
    @tracker.get_team_name(most_tackles_team[0])
  end

  def find_winningest_coach(game_ids)
    total_wins_and_games = game_and_win_count(game_ids, :head_coach, 'WIN', nil, true)
    sort_percentages(total_wins_and_games.first, total_wins_and_games.last).last[0]
  end

  def find_worst_coach(game_ids)
    total_wins_and_games = game_and_win_count(game_ids, :head_coach, 'WIN', nil, true)
    sort_percentages(total_wins_and_games.first, total_wins_and_games.last).first[0]
  end

  def favorite_opponent(team_id)
    game_ids = find_game_ids(team_id)
    total_games_and_results = game_and_win_count(game_ids, :team_id, 'LOSS', team_id)
    biggest_loser = sort_percentages(total_games_and_results.first, total_games_and_results.last)
    @tracker.get_team_name(biggest_loser.last[0])
  end

  def rival(team_id)
    game_ids = find_game_ids(team_id)
    total_games_and_results = game_and_win_count(game_ids, :team_id, 'WIN', team_id)
    biggest_winner = sort_percentages(total_games_and_results.first, total_games_and_results.last)
    @tracker.get_team_name(biggest_winner.last[0])
  end

  def game_and_win_count(game_ids, stat_query, expected_result, team_id = nil, teams_removed = false)
    @game_teams.each_with_object([{}, Hash.new(0)]) do |game, collectors|
      next unless game_ids.include?(game.game_id) && (teams_removed || game.stats[stat_query] != team_id)

      collectors.first[game.stats[stat_query]] ||= 0
      collectors.last[game.stats[stat_query]] += 1
      collectors.first[game.stats[stat_query]] += 1 if game.result == expected_result
    end
  end

  def find_all_games(team_id)
    @game_teams.find_all { |game| game.team_id == team_id }
  end

  def most_goals_scored(team_id)
    find_all_games(team_id).max_by { |game| game.goals }.goals
  end

  def fewest_goals_scored(team_id)
    find_all_games(team_id).min_by { |game| game.goals }.goals
  end

  def find_game_ids(team_id)
    find_all_games(team_id).map { |game| game.game_id }
  end
end
