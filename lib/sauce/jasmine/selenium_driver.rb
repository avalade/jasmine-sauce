require 'sauce'
module Sauce
  module Jasmine
    class SeleniumDriver
      def initialize(os, browser, browser_version, domain)
        host = host[7..-1] if host =~ /^http:\/\//
          base_url = "http://#{domain}"
        @driver = Sauce::Selenium.new(:browser => browser,
                                      :os => os,
                                      :browser_version => browser_version,
                                      :browser_url => base_url,
                                      :record_video => false,
                                      :record_screenshots => false,
                                      :job_name => "Jasmine")
      end

      def connect
        @driver.start
        @driver.open("/jasmine")
      end

      def disconnect
        @driver.stop
      end 

      def eval_js(script)
        escaped_script = "'" + script.gsub(/(['\\])/) { '\\' + $1 } + "'"

        result = @driver.get_eval("try { eval(#{escaped_script}, this.browserbot.getUserWindow()); } catch(err) { this.browserbot.getUserWindow().eval(#{escaped_script}); }")
        JSON.parse("{\"result\":#{result}}")["result"]
      end


      def tests_have_finished?
        eval_js("jsApiReporter && jsApiReporter.finished")
      end

      def test_suites
        eval_js("var result = jsApiReporter.suites(); if (window.Prototype && Object.toJSON) { Object.toJSON(result) } else { JSON.stringify(result) }")
      end

      def test_results
        eval_js("var result = {}; var apiResult = jsApiReporter.results(); for(var i in apiResult) { if(apiResult.hasOwnProperty(i)) { result[i] = {result: apiResult[i].result}; } } if(window.Prototype && Object.toJSON) { Object.toJSON(result); } else { JSON.stringify(result); }")
      end

      def job_id
        @driver.session_id
      end
    end
  end
end
