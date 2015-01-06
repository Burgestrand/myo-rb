require "myo/version"

require "libmyo"
require "ffi"

module Myo
  extend FFI::Library

  ffi_lib [Libmyo.binary_path, "myo"]

  typedef :pointer, :hub
  typedef :pointer, :out_hub
  typedef :pointer, :error_details
  typedef :pointer, :out_error
  typedef :pointer, :myo
  typedef :pointer, :event
  typedef :pointer, :user_data
  typedef :string, :application_identifier

  enum :result, [:success, :error, :error_invalid_argument, :error_runtime]
  enum :locking_policy, [:none, :standard]
  enum :vibration_type, [:short, :medium, :long]
  enum :stream_emg, [:disabled, :enabled]
  enum :pose, [:rest, :fist, :wave_in, :wave_out, :fingers_spread, :double_tap, :num_poses,
               :pose_unknown, 0xffff]
  enum :unlock_type, [:timed, :hold]
  enum :user_action_type, [:single]
  enum :event_type, [:paired, :unpaired, :connected, :disconnected, :arm_synced, :arm_unsynced, :orientation, :pose, :rssi, :unlocked, :locked, :emg]
  enum :handler_result, [:continue, :stop]

  attach_function :error_cstring, :libmyo_error_cstring, [:error_details], :string
  attach_function :error_kind, :libmyo_error_cstring, [:error_details], :result
  attach_function :free_error_details, :libmyo_error_cstring, [:error_details], :void

  attach_function :init_hub, :libmyo_init_hub, [:out_hub, :application_identifier, :out_error], :result
  attach_function :shutdown_hub, :libmyo_shutdown_hub, [:hub, :out_error], :result

  attach_function :set_locking_policy, :libmyo_set_locking_policy, [:hub, :locking_policy, :out_error], :result

  attach_function :vibrate, :libmyo_vibrate, [:myo, :vibration_type, :out_error], :result
  attach_function :request_rssi, :libmyo_request_rssi, [:myo, :out_error], :result

  attach_function :set_stream_emg, :libmyo_set_stream_emg, [:myo, :stream_emg, :out_error], :result

  attach_function :myo_unlock, :libmyo_myo_unlock, [:myo, :unlock_type, :out_error], :result
  attach_function :myo_lock, :libmyo_myo_lock, [:myo, :out_error], :result

  attach_function :myo_notify_user_action, :libmyo_myo_notify_user_action, [:myo, :user_action_type, :out_error], :result

  attach_function :event_get_type, :libmyo_event_get_type, [:event], :event_type
  attach_function :event_get_timestamp, :libmyo_event_get_timestamp, [:event], :uint64
  attach_function :event_get_myo, :libmyo_event_get_myo, [:event], :myo


  attach_function :event_get_pose, :libmyo_event_get_pose, [:event], :pose


  callback :handler, [:user_data, :event], :handler_result
  attach_function :run, :libmyo_run, [:hub, :uint, :handler, :user_data, :out_error], :result
end
