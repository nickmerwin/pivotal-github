require 'pivotal-github/command'
require 'pivotal-github/finished_command'

class StoryMerge < FinishedCommand

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git story-merge [options]"
      opts.on("-d", "--development BRANCH",
              "development branch (defaults to master)") do |opt|
        self.options.development = opt
      end
      opts.on("-f", "--force", "override unfinished story warning") do |opt|
        self.options.force = opt
      end
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line
  # For example:
  #   git checkout master
  #   git merge --no-ff <story branch>
  def cmd
    lines = ["git checkout #{development_branch}"]
    c = ['git merge --no-ff --log']
    c << argument_string(unknown_options) unless unknown_options.empty?
    c << story_branch
    lines << c.join(' ')
    lines.join("\n")
  end

  private

    def development_branch
      options.development || 'master'
    end
end