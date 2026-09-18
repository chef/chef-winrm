# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "logger" unless defined?(Logger)

module WinRM
  # Backwards-compatible default for `Connection#logger`.
  #
  # This library used to expose a `logging`-gem logger here; it now exposes a
  # plain stdlib {Logger} instead. This subclass keeps the one
  # `logging`-specific method callers actually used (`add_appenders`) working
  # while emitting a deprecation warning, so existing code keeps running
  # instead of breaking on upgrade. Everything else is exactly stdlib
  # `Logger` behavior.
  class CompatLogger < ::Logger
    # Accepts `logging`-gem-style appenders for backwards compatibility.
    # Stdlib loggers write to their log device, so appenders have no
    # equivalent here and are ignored.
    def add_appenders(*_appenders)
      deprecate_appenders unless @appenders_deprecated
      nil
    end

    private

    def deprecate_appenders
      @appenders_deprecated = true
      Kernel.warn "[DEPRECATION] WinRM: `logger.add_appenders` is deprecated and has no effect. " \
        "Configure the stdlib logger directly or inject your own via `Connection#logger=`."
    end
  end
end
