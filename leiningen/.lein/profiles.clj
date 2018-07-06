{:user {:plugins      [[jonase/eastwood "0.2.7"]
                       [lein-ancient "0.6.15"]
                       [lein-kibit "0.1.6"]
                       [slamhound "1.5.5"]
                       [criterium "0.4.4"]
                       [com.jakemccrary/lein-test-refresh "0.22.0"]]

        :dependencies [[pjstadig/humane-test-output "0.8.3"]
                       [org.clojure/tools.nrepl "0.2.13"]]

        :injections   [(require 'pjstadig.humane-test-output)
                       (pjstadig.humane-test-output/activate!)]

        :test-refresh {:notify-command ["terminal-notifier" "-title" "Tests" "-message"]
                       :quiet true
                       :changes-only true}

        :aliases      {"sanity-check" ["do" ["clean"] ["ancient"] ["kibit"]]}}

 :repl {:plugins      [[cider/cider-nrepl "0.17.0"]
                       [refactor-nrepl "2.3.0"]]}}

