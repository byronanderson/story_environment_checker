require 'sinatra'
require 'json'
require 'yaml'
require './environment_checker'


class App < Sinatra::Base
  get '/check_envs/:story_id' do
    content_type :json
    environments.each_with_object({}) do |environment, data|
      data[environment.name] = env_checker.check_for(story, env: environment)
    end.to_json
  end

  def env_checker
    EnvironmentChecker.new(repo)
  end

  def environments
    [Struct.new(:name, :deployed_sha).new('test', 'c8deb3cb582eb1218d8ae35f6d107036d5a81b6c')]
  end

  def repo
    @repo ||= Git.open(config["git_path"])
  end

  def config
    @config ||= YAML.load_file('config.yml')
  end

  def story
    Story.new(params[:story_id])
  end
end

Story = Struct.new(:id)
