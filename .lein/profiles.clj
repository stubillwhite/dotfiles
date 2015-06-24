{
  :user 
  {
    :plugins
    [ [cider/cider-nrepl "0.9.0"]
      [jonase/eastwood "0.2.1"]
      [lein-ancient "0.5.5"]
      [lein-kibit "0.1.2"]
      [lein-midje "3.1.3"] ]
    
    :aliases
    { "jfdi"
      ["do" ["clean"] ["ancient"] ["kibit"] ] } }
}
