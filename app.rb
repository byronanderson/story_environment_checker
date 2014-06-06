require 'sinatra'
require 'json'
require 'yaml'
require './environment_checker'

$environments = []
Dir["environments/*.rb"].each {|file| load file }

class App < Sinatra::Base
  get '/check_envs/:story_id' do
    content_type :json
    headers['Access-Control-Allow-Origin'] = '*'
    environments.each_with_object({}) do |environment, data|
      data[environment.name] = env_checker.check_for(story, env: environment)
    end.to_json
  end

  def env_checker
    EnvironmentChecker.new(repo)
  end

  def environments
    $environments
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
