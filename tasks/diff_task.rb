class DiffTask
  include Rake::DSL

  def define
    namespace :translate do
      desc "Show translation diff"
      task :diff do
        puts "translate:diff is called."
      end
    end
  end
end
