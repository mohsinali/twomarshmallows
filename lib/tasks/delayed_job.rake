namespace :delayed_job do  

  desc "Run all available jobs and then exit"
  task process_and_exit: :environment do
    puts "================== ENV #{Rails.env} =================="
    puts Time.now
    puts "Delayed Job Check - Process and Exit"
    puts Delayed::Job.all.size

    cmd = "bin/delayed_job start --exit-on-complete"
    begin
      system( cmd )      
    rescue Exception => e
      puts "=================== Exception - process_and_exit ==================="
      puts e.message
    end
  end
  
end