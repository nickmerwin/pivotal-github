require 'optparse'
require 'ostruct'
require 'pivotal-github/options'
require 'pivotal-github/command'

class Submit < Command

  # attr_accessor :branch

  def parse
    options = OpenStruct.new
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: git submit [options]"
      opts.on("-p", "--pull-request BRANCH",
              "submit a pull request to a branch other than master") do |b|
        options.branch = b
      end
      opts.on("-t", "--target TARGET",
              "push to a target other than origin") do |t|
        options.target = t
      end
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
    self.known_options   = Options::known_options(parser, args)
    self.unknown_options = Options::unknown_options(parser, args)
    parser.parse(known_options)
    options
  end

  # Returns a command appropriate for executing at the command line
  def cmd
    c = ['git push']
    c << target
    c << current_branch
    c << argument_string(unknown_options) unless unknown_options.empty?
    c.join(' ')
  end

  def run!
    system cmd
  end

  private

    def pull_request_branch
      options.branch || 'master'
    end

    def target
      options.target || 'origin'
    end
end