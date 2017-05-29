{:user {:plugins      [[jonase/eastwood "0.2.4"]
                       [lein-ancient "0.6.10"]
                       [lein-kibit "0.1.5"]
                       [slamhound "1.5.5"]
                       [criterium "0.4.4"]
                       [com.jakemccrary/lein-test-refresh "0.20.0"]]

        :dependencies [[pjstadig/humane-test-output "0.8.2"]
                       [org.clojure/tools.nrepl "0.2.13"]]

        :injections   [(require 'pjstadig.humane-test-output)
                       (pjstadig.humane-test-output/activate!)]

        :test-refresh {:notify-command ["terminal-notifier" "-title" "Tests" "-message"]
                       :quiet true
                       :changes-only true}

        :aliases      {"sanity-check" ["do" ["clean"] ["ancient"] ["kibit"]]}}

 :repl {:plugins      [[cider/cider-nrepl "0.14.0"]
                       [refactor-nrepl "2.3.0"]]}}

