(require '[clojure.java.io :as io])

(defn extract-tables [html tags]
  (let [[table-tag row-tag cell-tag] tags]
    (for [[_ table] (re-seq (re-pattern (str "(?s)<" table-tag ".*?>(.*?)</" table-tag ">")) html)]
      (let [rows (re-seq (re-pattern (str "(?s)<" row-tag ".*?>(.*?)</" row-tag ">")) table)]
        (for [[_ row] rows]
          (let [cells (re-seq (re-pattern (str "(?s)<" cell-tag ".*?>(.*?)</" cell-tag ">")) row)]
            (mapv (fn [[_ cell]]
                    (-> cell
                        (clojure.string/replace #"<.*?>" "")  ;; Remove HTML tags
                        (clojure.string/trim)))
                  cells)))))))

(defn get-output-filename [input-filename index]
  (let [base-name (clojure.string/replace input-filename #"\.[^.]+$" "")] ;; Remove extension
    (str base-name "_table_" (inc index) ".csv")))

(defn save-tables-to-csv [tables input-filename]
  (doseq [[index table] (map-indexed vector tables)]
    (let [filename (get-output-filename input-filename index)
          csv-content (clojure.string/join "\n" (map #(clojure.string/join "," %) table))] ;; Convert table to CSV format
      (spit filename csv-content)
      (println "Saved table to" filename))))


(save-tables-to-csv (extract-tables (slurp "wikipedia.html") ["table" "tr" "t[dh]"]), "wikipedia.html")
