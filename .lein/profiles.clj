{:user {:plugins [[cider/cider-nrepl "0.10.0-SNAPSHOT"]
                  [jonase/eastwood "0.2.1"]
                  [lein-ancient "0.6.8"]
                  [lein-kibit "0.1.2"]
                  [lein-midje "3.2"]
                  [lein-expectations "0.0.7"]
                  [lein-autoexpect "1.4.0"] 
                  [slamhound "1.5.5"]
                  [refactor-nrepl "2.0.0-SNAPSHOT"]]

        :aliases { "jfdi" ["do" ["clean"] ["ancient"] ["kibit"]]}}
 }
