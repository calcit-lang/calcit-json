
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `cr query` to inspect and `cr edit`/`cr tree` to modify. Run `cr docs agents --full` first. Manual edits must follow format and schema conventions, then run `cr edit format`.") (:package |json) (:version |0.0.9)
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'json.test/main!) (:mode :native) (:reload-fn 'json.test/reload!)
      :modules $ []
      :type-slots $ {}
  :files $ {}
    |json.core $ %{} 'FileEntry
      :defs $ {}
        |parse $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn parse (content)
              &call-dylib-edn (get-dylib-path |/dylibs/libcalcit_json) |json_parse content
          :examples $ []
          :schema $ :: 'Dynamic
        |stringify $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn stringify (data ? pretty?)
              &call-dylib-edn (get-dylib-path |/dylibs/libcalcit_json) |json_stringify data pretty?
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns json.core $ :require
            json.$meta :refer $ calcit-dirname
            json.util :refer $ get-dylib-path
    |json.test $ %{} 'FileEntry
      :defs $ {}
        |main! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn main! () $ run-tests
          :examples $ []
          :schema $ :: 'Dynamic
        |reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn reload! $
          :examples $ []
          :schema $ :: 'Dynamic
        |run-tests $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn run-tests () (println "|%%%% test for json") (println calcit-filename calcit-dirname)
              println |Parsing: $ parse "|{\"a\":[\"b\",1]}"
              println |Stringify: $ stringify
                {} $ :a 1
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns json.test $ :require
            json.core :refer $ parse stringify
            json.$meta :refer $ calcit-dirname calcit-filename
    |json.util $ %{} 'FileEntry
      :defs $ {}
        |get-dylib-ext $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defmacro get-dylib-ext () $ case-default (&get-os) |.so (:macos |.dylib) (:windows |.dll)
          :examples $ []
          :schema $ :: 'Dynamic
        |get-dylib-path $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-dylib-path (p)
              str (or-current-path calcit-dirname) p $ get-dylib-ext
          :examples $ []
          :schema $ :: 'Dynamic
        |or-current-path $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn or-current-path (p)
              if (blank? p) |. p
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns json.util $ :require
            json.$meta :refer $ calcit-dirname calcit-filename
