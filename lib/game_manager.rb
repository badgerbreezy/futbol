require 'csv'
require_relative './mathable'

class GameManager
  include Mathable
  attr_reader :games,
              :tracker
  def initialize(path, tracker)
    @games = []
    create_underscore_games(path)
    @tracker = tracker
  end

  def create_underscore_games(path)
    games_data = CSV.read(path, headers: true)
    @games = games_data.map do |data|
      Game.new(data, self)
    end
  end

  def highest_total_score
    highest_score = @games.max_by { |game| game.away_goals + game.home_goals }
    highest_score.away_goals + highest_score.home_goals
  end

  def lowest_total_score
    lowest_score = @games.min_by { |game| game.away_goals + game.home_goals }
    lowest_score.away_goals + lowest_score.home_goals
  end

  def percentage_home_wins 
    home_wins = @games.count { |game| game.home_goals > game.away_goals }
    (home_wins.to_f / games.length).round(2)
  end

  def percentage_visitor_wins
    visitor_wins = @games.count { |game| game.away_goals > game.home_goals }
    (visitor_wins.to_f / games.length).round(2)
  end

  def percentage_ties
    tie_games = @games.count { |game| game.away_goals == game.home_goals }
    (tie_games.to_f / games.length).round(2)
  end

  def average_goals_by_season
    average_goals_season = Hash.new(0)
    games_by_season = count_of_games_by_season
    @games.each do |game|
      average_goals_season[game.season] += (game.home_goals + game.away_goals)
    end
    average_goals_season.map do |season, goals|
      [season, (goals.to_f / games_by_season[season].to_f).round(2)]
    end.to_h
  end

  def highest_scoring_visitor
    away_points_and_games = game_and_stat_count(@games, :away_team_id, :away_goals)
    highest_scoring_visitor = sort_percentages(away_points_and_games.first, away_points_and_games.last)
    @tracker.get_team_name(highest_scoring_visitor.last[0])
  end

  def highest_scoring_home_team
    home_points_and_games = game_and_stat_count(@games, :home_team_id, :home_goals)
    highest_scoring_home_team = sort_percentages(home_points_and_games.first, home_points_and_games.last)
    @tracker.get_team_name(highest_scoring_home_team.last[0])
  end

  def lowest_scoring_visitor
    away_points_and_games = game_and_stat_count(@games, :away_team_id, :away_goals)
    lowest_scoring_visitor = sort_percentages(away_points_and_games.first, away_points_and_games.last)
    @tracker.get_team_name(lowest_scoring_visitor.first[0])
  end

  def get_season_game_ids(season)
    games_in_season = @games.select { |game| game.season == season }
    games_in_season.map { |game| game.game_id }
  end

  def lowest_scoring_home_team
    home_points_and_games = game_and_stat_count(@games, :home_team_id, :home_goals)
    lowest_scoring_home_team = sort_percentages(home_points_and_games.first, home_points_and_games.last)
    @tracker.get_team_name(lowest_scoring_home_team.first[0])
  end

  def wins_per_season(team_id, wins_by, games_by)
    @games.each do |game|
      if game.home_team_id == team_id || game.away_team_id == team_id
        games_by[game.season] << game
      end
    end
    games_by.each do |season, games|
      games.each do |game|
        if game.home_team_id == team_id && game.home_goals > game.away_goals
          wins_by[season] += 1
        elsif game.away_team_id == team_id && game.away_goals > game.home_goals
          wins_by[season] += 1
        end
      end
    end
  end

  def best_season(team_id)
    wins_by_season = Hash.new(0.0)
    games_by_season = Hash.new { |hash, key| hash[key] = [] }
    wins_per_season(team_id, wins_by_season, games_by_season)
    games_by_season.max_by do |season, games|
      wins_by_season[season] / games.length
    end[0]
  end

  def worst_season(team_id)
    wins_by_season = Hash.new(0.0)
    games_by_season = Hash.new { |hash, key| hash[key] = [] }
    wins_per_season(team_id, wins_by_season, games_by_season)
    games_by_season.min_by do |season, games|
      wins_by_season[season] / games.length
    end[0]
  end

  def winningest_coach(season)
    game_ids = get_season_game_ids(season)
    @tracker.find_winningest_coach(game_ids)
  end

  def worst_coach(season)
    game_ids = get_season_game_ids(season)
    @tracker.find_worst_coach(game_ids)
  end

  def count_of_games_by_season
    @games.reduce(Hash.new(0)) do |collector, game|
      collector[game.season] += 1
      collector
    end
  end

  def average_goals_per_game
    average_goals = @games.sum { |game| game.home_goals + game.away_goals }
    (average_goals.to_f / games.length).round(2)
  end
end
