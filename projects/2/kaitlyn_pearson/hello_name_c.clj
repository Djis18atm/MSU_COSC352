
(def args *command-line-args*)
 (println "Arguments received:" args)

 (if (= (count args) 2)
   (let [name (first args)
         count (Integer. (second args))]
     (dotimes [_ count]
       (println (str "Hello, " name "!"))))
   (println "Usage: hello-name-c <name> <count>"))
