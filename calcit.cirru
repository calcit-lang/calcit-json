
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --full` first. Manual edits must follow format and schema conventions, then run `calcit edit format`.") (:package |json)
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'json.test/main!) (:mode :native) (:reload-fn 'json.test/reload!)
      :feature-policy $ {}
      :modules $ []
      :type-slots $ {}
  :files $ {}
    |json.core $ %{} 'FileEntry
      :defs $ {}
        |parse $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn parse (content)
              tag-match
                &call-dylib-edn (get-dylib-path |/dylibs/libcalcit_json) |json_parse_result content
                (:ok value) value
                (:err message) (raise message)
          :examples $ []
          :ffi $ {} (:backend :native) (:symbol |json_parse_result)
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ [] 'String
        |parse-result $ %{} 'CodeEntry (:doc "|Parse JSON into a typed Result. Invalid input returns Result.err instead of raising across the native boundary.")
          :code $ quote
            defn parse-result (content)
              tag-match
                &call-dylib-edn (get-dylib-path |/dylibs/libcalcit_json) |json_parse_result content
                (:ok value) (%ok value)
                (:err message) (%err message)
          :examples $ []
            quote $ assert=
              %ok $ {} (|a 1)
              parse-result "|{\"a\":1}"
          :schema $ :: 'Fn
            {}
              :args $ [] 'String
              :return $ :: 'Result 'Dynamic 'String
          :tests $ []
            %{} 'TestEntry (:name |returns-errors-for-invalid-json)
              :code $ quote
                assert |invalid-JSON-should-return-err $ result:err? (parse-result |{)
              :tags $ #{} :unit
        |stringify $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn stringify (data ? pretty?)
              tag-match
                &call-dylib-edn (get-dylib-path |/dylibs/libcalcit_json) |json_stringify_result data pretty?
                (:ok value) value
                (:err message) (raise message)
          :examples $ []
          :ffi $ {} (:backend :native) (:symbol |json_stringify_result)
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'Dynamic 'Bool
        |stringify-result $ %{} 'CodeEntry (:doc "|Serialize a value into a typed Result. Unsupported EDN values and invalid map keys return Result.err.")
          :code $ quote
            defn stringify-result (data pretty?)
              tag-match
                &call-dylib-edn (get-dylib-path |/dylibs/libcalcit_json) |json_stringify_result data $ pretty? .unwrap-or false
                (:ok value) (%ok value)
                (:err message) (%err message)
          :examples $ []
            quote $ assert= (%ok "|{\"a\":1}")
              stringify-result $ {} (:a 1)
          :schema $ :: 'Fn
            {}
              :args $ [] 'Dynamic (:: 'Option 'Bool)
              :return $ :: 'Result 'String 'String
          :tests $ []
            %{} 'TestEntry (:name |returns-errors-for-unsupported-values)
              :code $ quote
                assert |unsupported-values-should-return-err $ result:err?
                  stringify-result $ {} (1 |value)
              :tags $ #{} :unit
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
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
        |reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn reload! $
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
        |run-tests $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn run-tests () (println "|%%%% test for json") (println calcit-filename calcit-dirname)
              println |Parsing: $ parse "|{\"a\":[\"b\",1]}"
              println |Stringify: $ stringify
                {} $ :a 1
              do
                assert |valid-JSON-should-return-ok $ result:ok? (parse-result "|{\"a\":1}")
                assert |invalid-JSON-should-return-err $ result:err? (parse-result |{)
                assert= (%ok "|{\"a\":1}")
                  stringify-result $ {} (:a 1)
              println |Safe-Result-APIs-passed
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Unit)
              :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns json.test $ :require
            json.core :refer $ parse stringify parse-result stringify-result
            json.$meta :refer $ calcit-dirname calcit-filename
    |json.util $ %{} 'FileEntry
      :defs $ {}
        |get-dylib-ext $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defmacro get-dylib-ext () $ case-default (&get-os) |.so (:macos |.dylib) (:windows |.dll)
          :examples $ []
          :ffi $ {} (:backend :native)
          :schema $ :: 'Macro
            {}
              :capabilities $ #{} :platform-read
              :expansion $ :: 'Expr 'String
              :required $ []
        |get-dylib-path $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-dylib-path (p)
              str (or-current-path calcit-dirname) p $ get-dylib-ext
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String
        |or-current-path $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn or-current-path (p)
              if (blank? p) |. p
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'String)
              :args $ [] 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns json.util $ :require
            json.$meta :refer $ calcit-dirname calcit-filename
