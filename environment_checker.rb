require 'git'
class EnvironmentChecker
  attr_reader :repo
  def initialize(repo)
    @repo = repo
  end

  def check_for(story, env:)
    missing_commits_for(story, env: env).none?
  end

  private

  def missing_commits_for(story, env:)
    deployed_commits = deployed_commits_for(story, env: env)
    relevant_commits_for(story).reject { |commit|
      deployed_commits.any? { |deployed|
        deployed.message == commit.message
      }
    }
  end

  def relevant_commits_for(story)
    repo.checkout 'master'
    find_commits_mentioning(story)
  end

  def deployed_commits_for(story, env:)
    repo.checkout env.deployed_sha
    find_commits_mentioning(story)
  end

  def find_commits_mentioning(story)
    repo.log.select { |commit| commit.message.include?("##{story.id}") }
  end
end
