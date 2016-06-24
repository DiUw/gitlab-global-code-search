#!/usr/bin/env ruby
require 'json'
require 'optparse'
require 'yaml'

class GitlabCodeSearcher
  # Some ansi for better readability
  BLUE = "\033[34m"
  GREEN = "\033[32m"
  MAGENTA = "\033[35m"
  NC = "\033[0m"

  def initialize
    @conf = YAML.load_file(File.join(__dir__, 'config.yml'))
    cputs('Configured GitLab repo :', @conf[GITLAB_URL], GREEN)
  end

  # Be more readable on ANSI consoles. Use less -R to see nice output if stored in file
  def cputs(what, what1 = '', color = BLUE)
    puts "#{color}#{what}#{NC} #{what1}"
  end

  # Loads all projects into local file. Page by page, 100 entries each
  def rehash_gitlab_projects
    puts 'Loading project list from GitLab to local projects.txt'

    projects = []
    i = 0
    until (part = `curl "#{@conf[GITLAB_URL]}/api/v3/projects/all?page=#{i += 1}&per_page=100&private_token=#{@conf[PRIVATE_TOKEN]}"`).eql? '[]'
      puts "Adding #{i}th 100 entries"
      projects << JSON.parse(part).flatten
    end
    File.open('projects.txt', 'w') { |file| file.write(JSON.generate(projects.flatten)) }
  end

  # search in one gitlab Project
  def search_in_project(id, name, _url, what)
    res = `curl -s --header "PRIVATE-TOKEN: #{@conf[PRIVATE_TOKEN]}" '#{@conf[GITLAB_URL]}/search?utf8=%E2%9C%93&search=#{what}&group_id=&project_id=#{id}&search_code=true&repository_ref=master'`
    if res.include?("We couldn't find any results matching") || !res.include?('fa fa-file')
      cputs "In project '#{name}' ... nothing", '', BLUE
      return
    end

    cputs "In project '#{name}'", '', BLUE
    cputs '************************************', '', BLUE

    links = res.split("\n").grep(/fa fa-file/).map { |el| el.split('">')[0].split('<a href="')[1] }
    i = -1
    res.split('<strong>').each do |block|
      next unless block.include? 'class="line"'
      name = block.split('</strong>')[0].delete!("\n")

      cputs "\nFound in '#{name}'", "#{@conf[GITLAB_URL]}/#{links[i += 1]}", BLUE

      block.split("\n").grep(/class="line"/).each do |line|
        str = line.gsub(/(<[^>]*>)|\n|\t/su) { ' ' }
        puts str.gsub /#{what}/i, "#{GREEN}#{what}#{NC}"
      end
    end
  end

  # Loads all projects into local file. Page by page, 100 entries each
  def search(what, namespaces, recache)
    puts
    cputs('Searching for :', '', GREEN)
    cputs('What =', what, GREEN)
    cputs('In namespaces =', namespaces, GREEN)
    cputs('Recaching repo list before search =', recache, GREEN)
    puts

    rehash_gitlab_projects if recache || !File.file?('projects.txt')

    projects = File.read('projects.txt')
    JSON.parse(projects).each do |el|
      next unless namespaces.eql?('all') || namespaces.include?(el['namespace']['name'])
      search_in_project el['id'], el['name'], el['web_url'], what
    end
  end
end

# If script is run, execute. Spec run skips this section
$dryrun = false
$rehash = false

parser = OptionParser.new do |opt|
  opt.on('-r', '--recache') do |_arg|
    $rehash = true
  end
  opt.on('-s', '--search-string SEARCH_STRING', '[REQUIRED]') do |str|
    $search_string = str
  end
  opt.on('-n', '--namespaces NAMESPACES', '[REQUIRED] Comma separated list of namespaces (you can set namespaces=all to search through all Gitlab repos, but mind the Load on the server') do |str|
    $namespaces = str
  end
  opt.on_tail('-h', '--help') do |_arg|
    puts opt
    exit
  end
end
parser.parse!(ARGV)

if $search_string.nil? || $search_string.empty? || $namespaces.nil? || $namespaces.empty?
  puts 'search_string and namespaces are required'
  puts parser
  exit -1
end

exit -1 unless GitlabCodeSearcher.new.search($search_string, $namespaces, $recache)
