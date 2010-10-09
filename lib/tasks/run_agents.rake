################################################################################
namespace :agents do
  ################################################################################
  desc 'Run all agents'
  task :up do
    puts ENV['RAILS_ENV']
    environment = ENV['RAILS_ENV'] || 'development'

    if (running = %x[ps ax | grep new_tasker.rb | grep -vc grep]) && (running.to_i == 1)
      puts 'new_tasker.rb is already running.'
    else
      puts 'Running new_tasker.rb'
      system "ruby '#{File.join File.dirname(__FILE__), '/../serial/agent/new_tasker.rb'}' #{ENV['HOUSE'] || 'all'} #{environment} &"
    end

    if (running = %x[ps ax | grep reader.rb | grep -vc grep]) && (running.to_i == 1)
      puts 'reader.rb is already running.'
    else
      puts 'Running reader.rb.'
      system "ruby '#{File.join File.dirname(__FILE__), '/../serial/agent/reader.rb'}' #{environment} &"
    end
  end

  ################################################################################
  desc 'Kill all agents'
  task :down do
    if (running = %x[ps ax | grep new_tasker.rb | grep -v grep]).size > 0
      puts 'Killed new_tasker.rb.'
      system "kill -9 #{running.split.first}"
    else
      puts 'new_tasker.rb is not running.'
    end

    if (running = %x[ps ax | grep reader.rb | grep -v grep]).size > 0
      puts 'Killed reader.rb.'
      system "kill -9 #{running.split.first}"
    else
      puts 'reader.rb is not running.'
    end
  end
end