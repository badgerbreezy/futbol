require 'csv'

class Team
  attr_reader :manager,
              :team_id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :stadium,
              :link

  def initialize(data, manager)
    @manager = manager
    @team_id = data["team_id"]
    @franchise_id = data["franchiseId"]
    @team_name = data["teamName"]
    @abbreviation = data["abbreviation"]
    @stadium = data["Stadium"]
    @link = data["link"]
  end
end