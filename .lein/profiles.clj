{
  :user 
  {
    :plugins
    [ [cider/cider-nrepl "0.9.1"]
      [jonase/eastwood "0.2.1"]
      [lein-ancient "0.6.7"]
      [lein-kibit "0.1.2"]
      [lein-midje "3.1.3"] ]
    
    :aliases
    { "jfdi"
      ["do" ["clean"] ["ancient"] ["kibit"] ] } }
}
