require "bundler/gem_tasks"

task :default do
  require "myo"

  stop = false

  hub_ptr = FFI::MemoryPointer.new(:pointer)
  err_ptr = FFI::MemoryPointer.new(:pointer)
  result  = Myo.init_hub(hub_ptr, "se.burgestrand.myo", err_ptr)

  hub = hub_ptr.read_pointer
  err = err_ptr.read_pointer

  p result
  if err.null?
    callback = lambda do |pointer, event|
      type = Myo.event_get_type(event)
      unless [:orientation].include?(type)
        timestamp = Myo.event_get_timestamp(event)
        time = Time.at(timestamp.fdiv(1000))
        p ["event!", type, time]
      end

      case type
      when :pose
        puts "  #{Myo.event_get_pose(event).inspect}"
      end

      if stop
        :stop
      else
        :continue
      end
    end
    Myo.run(hub, 60 * 1000, callback, nil, err_ptr)
  else
    p Myo.error_kind(err)
    p Myo.error_cstring(err)
  end
end
