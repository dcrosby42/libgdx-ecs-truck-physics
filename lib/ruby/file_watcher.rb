require 'thread'

class FileWatcher
  def initialize
    @source_times = {}
    @listeners = []
    @mutex = Mutex.new
  end

  def watch_for_mods(fname)
    @mutex.synchronize do
      @source_times[fname] = File.stat(fname).mtime
    end
  end

  def on_file_changed(&block)
    @listeners << block
  end

  def start
    Thread.new { run }
  end

  def stop
    @alive = false
  end

  def run
    @alive = true
    while @alive
      check_mod_times
    end
  end
  
  def check_mod_times
    sleep 0.2

    @mutex.synchronize do
      @source_times.each do |fname, last_time|
        mtime = File.stat(fname).mtime
        if mtime != last_time
          @source_times[fname] = mtime
          @listeners.each do |x| x.call(fname,mtime) end
        end
      end
    end
  end
end
