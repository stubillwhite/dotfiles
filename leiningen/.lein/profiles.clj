{:user {:plugins      [[jonase/eastwood "0.3.5"]
                       [lein-ancient "0.6.15"]
                       [lein-kibit "0.1.6"]
                       [lein-cloverage "1.1.1"]
                       [criterium "0.4.4"]
                       [com.jakemccrary/lein-test-refresh "0.23.0"]]

        :dependencies [[pjstadig/humane-test-output "0.9.0"]
                       [nrepl "0.6.0"]]

        :cloverage    {:ns-exclude-regex [#"user"]}

        :injections   [(require 'pjstadig.humane-test-output)
                       (pjstadig.humane-test-output/activate!)]

        :test-refresh {:notify-command ["lein-autotest-notify"]
                       :quiet true
                       :changes-only true}

        :aliases      {"check"        ["do" ["clean"] ["ancient"] ["kibit"]]
                       "coverage"     ["do" ["cloverage"]]
                       "autotest"     ["do" ["test-refresh"]]}}

 :repl {:plugins      [[cider/cider-nrepl "0.21.1"]
                       ;; [refactor-nrepl "2.3.0"] -- v2.3.0 seems to be incompatible with cider-nrepl 0.17.0
                       ]}}

