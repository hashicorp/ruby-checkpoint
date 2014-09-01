require "cgi"
require "json"
require "net/http"
require "uri/http"

require "checkpoint/platform"
require "checkpoint/version"

module Checkpoint
  # Checks for the latest version information as well as alerts.
  #
  # @param [Hash] opts the options to check with
  # @option opts [String] :product The product
  # @option opts [String] :version The version of the product
  # @option opts [String] :arch The arch this is running on. If not specified,
  #   we will try to determine it.
  # @option opts [String] :os The OS this is running on. If not specified,
  #   we will try to determine it.
  # @option opts [String] :signature A signature to eliminate duplicates
  def self.check(**opts)
    # Build the query parameters
    query = {
      version: opts[:version],
      arch: opts[:arch],
      os: opts[:os],
      signature: opts[:signature],
    }
    query[:arch] ||= Platform.arch
    query[:os] ||= Platform.os

    # Turn the raw query parameters into a proper query string
    query = query.map do |k, v|
      if v
        [CGI.escape(k.to_s), "=", CGI.escape(v.to_s)].join
      end
    end.compact.join("&")

    # Build the URL
    uri = URI::HTTP.build(
      host: "api.checkpoint.hashicorp.com",
      path: "/v1/check/#{opts[:product]}",
      query: query,
    )

    headers = { "Accept" => "application/json" }
    http = Net::HTTP.new(uri.host, uri.port)
    JSON.parse(http.get(uri.path, headers).body).tap do |result|
      result["outdated"] = !!result["outdated"]
    end
  end
end
