(defn extract-tables [html]
  (let [table-pattern #"(?s)<table.*?>(.*?)</table>" ;; Capture entire table
        row-pattern #"(?s)<tr.*?>(.*?)</tr>"         ;; Capture table rows
        cell-pattern #"(?s)<t[dh].*?>(.*?)</t[dh]>"  ;; Capture table cells
        tables (re-seq table-pattern html)]          

    (for [[_ table] tables]
      (let [rows (re-seq row-pattern table)]
        (for [[_ row] rows] ;; Extract row content
          (let [cells (re-seq cell-pattern row)]
            (mapv (fn [[_ cell]]
                    (-> cell
                        (clojure.string/replace #"<.*?>" "")  ;; Remove HTML tags
                        (clojure.string/trim)))
                  cells)))))))

(defn save-tables-to-csv [tables]
  (doseq [[index table] (map-indexed vector tables)]
    (let [filename (str "table_" (inc index) ".csv")
          csv-content (clojure.string/join "\n" (map #(clojure.string/join "," %) table))] ;; Convert table to CSV format
      (spit filename csv-content)
      (println "Saved table to" filename))))

(defn read-html-file [filename]
  (slurp filename)) ;; Reads the entire file as a string

(def html-content (read-html-file "wikipedia.html"))
(def extracted-tables (extract-tables html-content))
(save-tables-to-csv extracted-tables)
