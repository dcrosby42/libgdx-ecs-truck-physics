
class FileWatcher
  def initialize
    @source_times = {}
    @listeners = []
  end

  def watch_for_mods(fname)
    @source_times[fname] = File.stat(fname).mtime
  end

  def on_file_changed(&block)
    @listeners << block
  end

  def run
    Thread.new do
      loop do
        check_mod_times
      end
    end
  end
  
  def check_mod_times
    sleep 0.2
    @source_times.each do |fname, last_time|
      mtime = File.stat(fname).mtime
      if mtime != last_time
        @source_times[fname] = mtime
        @listeners.each do |x| x.call(fname,mtime) end
        #reload_car
      end
    end
  end
end
