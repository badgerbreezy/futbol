module Mathable
  def sort_percentages(numerator, denominator)
    numerator.sort_by do |team_name, statistic|
      statistic.to_f / denominator[team_name]
    end
  end

  def game_and_stat_count(source, team_id, stat)
    source.each_with_object([Hash.new(0), Hash.new(0)]) do |game, collectors|
      collectors.first[game.stats[team_id]] += game.stats[stat]
      collectors.last[game.stats[team_id]] += 1
    end
  end
end
