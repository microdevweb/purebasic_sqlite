; ---------------------------------------------------------------------------------------------------------
; LIBRARY NAME  : sqlite
; PROCESS       : manage sqlite database
; AUTHOR        : microdeWeb
; MAJOR VERSION : 1
; MINOR VERSION : 1
; DATE          : 2020/01/31
; ---------------------------------------------------------------------------------------------------------
DeclareModule sqlite
  Global FILE_PATH.s = ""                      ; the directory of database
  Global LOG_PATH.s = ""                       ; the directory of log file
  Global FILE_NAME.s = ""                      ; database file name
  Global LOG_NAME.s = ""                       ; log file name or empty if you don't write log
  Global logOnlyIfError.b = #False             ; set true if you want write only the sql error                                         ; false if you want draw all update requests
  Interface obj
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : open
    ; PROCESS             : open the database
    ; ARGUMENT            : void
    ; RETURN              : true if success or false if failure
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    open()
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : close
    ; PROCESS             : close the database  and free the object
    ; ARGUMENT            : void
    ; RETURN              : void
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    close()
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : query
    ; PROCESS             : send a query to database
    ; ARGUMENT            : request.s -> request to send
    ; RETURN              : #true if success or #false if failure
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    query(request.s)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : get_error
    ; PROCESS             : get the last error after a query or update
    ; ARGUMENT            : void
    ; RETURN              : error message
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    getError.s()
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : update
    ; PROCESS             : send a update message to database
    ; ARGUMENT            : request.s -> request to send
    ; RETURN              : #True if success or #False if failure
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    update(request.s)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : next_row
    ; PROCESS             : get next database row
    ; ARGUMENT            : void
    ; RETURN              : #True if next row or #False if not
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    nextRow()
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : get_string
    ; PROCESS             : get string from current row of database
    ; ARGUMENT            : column
    ; RETURN              : string 
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    getString.s(column)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : get_long
    ; PROCESS             : get long form current row of database
    ; ARGUMENT            : column
    ; RETURN              : long
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    getLong(column)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : get_double
    ; PROCESS             : get double form current row of database
    ; ARGUMENT            : column
    ; RETURN              : double
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    getDouble.d(column)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : get_float
    ; PROCESS             : get float form current row of database
    ; ARGUMENT            : column
    ; RETURN              : float
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    getFloat.f(column)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : get_quad
    ; PROCESS             : get quad from current row of database
    ; ARGUMENT            : column
    ; RETURN              : quad
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    getQuad.q(column)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : setLong
    ; PROCESS             : set long  of request
    ; ARGUMENT            : column,value
    ; RETURN              : void
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    setLong(column,value)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : setFloat
    ; PROCESS             : set float  of request
    ; ARGUMENT            : column,value.f
    ; RETURN              : void
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    setFloat(column,value.f)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : setDouble
    ; PROCESS             : set doulbe  of request
    ; ARGUMENT            : column,value.d
    ; RETURN              : void
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    setDouble(column,value.d)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : setQuad
    ; PROCESS             : set quad  of request
    ; ARGUMENT            : column,value.q
    ; RETURN              : void
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    setQuad(column,value.q)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : setString
    ; PROCESS             : set string  of request
    ; ARGUMENT            : column,value.s
    ; RETURN              : void
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    setString(column,value.s)
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : finish_query
    ; PROCESS             : finish a query request
    ; ARGUMENT            : column
    ; RETURN              : quad
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    finishQuery()
    ;{ --------------------------------------------------------------------------------------------------------
    ; PUBLIC METHOD       : getIdColumn
    ; PROCESS             : return column index from its name
    ; ARGUMENT            : name.s
    ; RETURN              : index of column
    ; MAJOR VERSION       : 1
    ; MINOR VERSION       : 1
    ; NOTE                :
    ;} --------------------------------------------------------------------------------------------------------
    getIdColumn(name.s)
  EndInterface
  ;{--------------------------------------------------------------------------------------------------------
  ; PUBLIC CONSTRUCTOR  : new
  ; ARGUMENT            : void
  ; RETURN              : instance of object
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;}--------------------------------------------------------------------------------------------------------
  Declare new() 
EndDeclareModule

XIncludeFile "../lib/_sqlite.pbi"
; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 198
; FirstLine = 128
; Folding = Pg--
; EnableXP