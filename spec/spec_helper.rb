require 'csv'
require 'crashing_the_dance/rpi_calculator'

Team = Struct.new(:name, :id) do
  def eql?(other)
    name.eql?(other.name)
  end

  def hash
    name.hash
  end
end

Game = Struct.new(:vis_team, :home_team, :vis_score, :home_score, :neutral, :conference) do
  def neutral?
    !neutral.nil? && neutral == "N"
  end

  def conference?
    !conference.nil? && conference == "C"
  end
end

def games_fixture(which)
  file = File.join(File.dirname(__FILE__), "fixtures", "games-#{which}.csv")
  teams = teams_fixture which
  games = []
  CSV.foreach(file, :headers => true) do |row|
    #puts "It's a game: #{row}"
    #puts "teams #{teams}"
    next if row.nil? || row.empty?
    games << Game.new(teams.find { |team| team.name.eql?(row["vis_team"]) },
                      teams.find { |team| team.name.eql?(row["home_team"]) },
                      row["vis_score"].to_i,
                      row["home_score"].to_i,
                      row["neutral"], row["conference"])
  end
  games
end

def teams_fixture(which, id = 1)
  file = File.join(File.dirname(__FILE__), "fixtures", "teams-#{which}.csv")
  teams = []
  CSV.foreach(file, :headers => true) do |team|
    teams << Team.new(team["name"], id) unless team.nil? || team["name"].nil? || team["name"].empty?
    id += 1
  end
  teams
end
