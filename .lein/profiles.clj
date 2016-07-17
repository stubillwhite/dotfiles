{
 :user {:plugins      [[jonase/eastwood "0.2.3"]
                       [lein-ancient "0.6.10"]
                       [lein-kibit "0.1.2"]
                       [slamhound "1.5.5"]
                       [criterium "0.4.4"]]

        :dependencies [[org.clojure/tools.nrepl "0.2.12"]]
        
        :aliases      {"sanity-check" ["do" ["clean"] ["ancient"] ["kibit"]]}}

 :repl {:plugins      [[cider/cider-nrepl "0.12.0"]
                       [refactor-nrepl "2.2.0"]]}
}
