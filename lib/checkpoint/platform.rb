# Copyright IBM Corp. 2014, 2025
# SPDX-License-Identifier: MPL-2.0

require "rbconfig"

module Checkpoint
  class Platform
    def self.arch
      if ["x86_64", "amd64"].include?(RbConfig::CONFIG["host_cpu"])
        return "amd64"
      end

      return "386"
    end

    def self.os
      RbConfig::CONFIG["host_os"].downcase
    end
  end
end
