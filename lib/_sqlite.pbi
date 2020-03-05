; ---------------------------------------------------------------------------------------------------------
; LIBRARY NAME  : sqlite
; PROCESS       : manage sqlite database
; AUTHOR        : Bielen Pierre
; MAJOR VERSION : 1
; MINOR VERSION : 1
; DATE          : 2020/01/31
; ---------------------------------------------------------------------------------------------------------
Module sqlite
  EnableExplicit
  UseSQLiteDatabase()
  Structure _struct
    *methods
    name.s
    log_path.s
    id.i
  EndStructure
  EnumerationBinary  
    #LOG_QUERY
    #LOG_UDPATE
    #LOG_ERROR
    #LOG_SETLONG
    #LOG_SETFLOAT
    #LOG_SETDOUBLE
    #LOG_SETQUAD
    #LOG_SETSTRING
  EndEnumeration
  
  Procedure writeLog(*this._struct,req.s,flags)
    Protected f,d.s,text.s
    With *this
      If logOnlyIfError And Not (flags & #LOG_ERROR) = #LOG_ERROR
        ProcedureReturn 
      EndIf
      If Len(LOG_NAME)
        f = OpenFile(#PB_Any,\log_path,#PB_File_Append)
        If Not f
          MessageRequester("LOG WRITE ERROR","Cannot open file "+\log_path,#PB_MessageRequester_Error)
          ProcedureReturn 
        EndIf
        d = FormatDate("%yyyy-%mm-%dd  %hh : %ii : %ss",Date())
        text = d 
        If (flags & #LOG_ERROR) = #LOG_ERROR
          text + " ERROR : "
        EndIf
        If (flags & #LOG_UDPATE) = #LOG_UDPATE
          text + " UPDATE : "
        EndIf
        If (flags & #LOG_QUERY) = #LOG_QUERY
          text + " QUERY : "
        EndIf
        If (flags & #LOG_SETLONG) = #LOG_SETLONG
          text + " SET_LONG : "
        EndIf
        If (flags & #LOG_SETFLOAT) = #LOG_SETFLOAT
          text + " SET_FLOAT : "
        EndIf
        If (flags & #LOG_SETDOUBLE) = #LOG_SETDOUBLE
          text + " SET_DOUBLE : "
        EndIf
        If (flags & #LOG_SETQUAD) = #LOG_SETQUAD
          text + " SET_QUAD : "
        EndIf
        If (flags & #LOG_SETSTRING) = #LOG_SETSTRING
          text + " SET_STRING : "
        EndIf
        text + req +" "
        If (flags & #LOG_ERROR) = #LOG_ERROR
          text + DatabaseError()
        EndIf
        text + Chr(10)
        WriteString(f,text)
        CloseFile(f)
      EndIf
    EndWith
  EndProcedure
  
  ;{--------------------------------------------------------------------------------------------------------
  ; PUBLIC CONSTRUCTOR  : new
  ; ARGUMENT            : path.s -> full path of database file with extend (.db,.slqite)
  ;                       log_path = the file path for save log of action or empty for not manage a log file
  ; RETURN              : instance of object
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;}--------------------------------------------------------------------------------------------------------
  Procedure  new() 
    Protected *this._struct = AllocateStructure(_struct)
    With *this
      \methods = ?S_MTH
      \name = FILE_PATH+"/"+FILE_NAME
      \log_path = LOG_PATH+"/"+LOG_NAME
      ; we create the directory if doesn't exist
      If FileSize(FILE_PATH) <> -2
        CreateDirectory(FILE_PATH)
      EndIf
      If Len(LOG_NAME)
        If FileSize(LOG_PATH) <> -2
          CreateDirectory(LOG_PATH)
        EndIf
      EndIf
      ; we create the log file if doens't exist
      If Len(LOG_NAME)
        If FileSize(\log_path) = -1
          If Not CreateFile(0,\log_path)
            MessageRequester("SQLITE ERROR","cannot create the file "+\log_path,#PB_MessageRequester_Error)
            ProcedureReturn 0
          EndIf
          CloseFile(0)
        EndIf
      EndIf
      ; we create the file if doesn't exist
      If FileSize(\name) = -1
        If Not CreateFile(0,\name)
          MessageRequester("SQLITE ERROR","cannot create the file "+\name,#PB_MessageRequester_Error)
          ProcedureReturn 0
        EndIf
        CloseFile(0)
      EndIf
      ProcedureReturn *this
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : open
  ; PROCESS             : open the database
  ; ARGUMENT            : void
  ; RETURN              : true if success or false if failure
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure open(*this._struct)
    With *this
      \id = OpenDatabase(#PB_Any,\name,"","")
      If \id
        ProcedureReturn #True
      EndIf
      writeLog(*this,"CANNOT OPEN DATABASE",#LOG_ERROR)
      ProcedureReturn #False
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : close
  ; PROCESS             : close the database and free the object
  ; ARGUMENT            : void
  ; RETURN              : void
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure close(*this._struct)
    With *this
      If IsDatabase(\id)
        CloseDatabase(\id)
        FreeStructure(*this)
      EndIf
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : query
  ; PROCESS             : send a query to database
  ; ARGUMENT            : request.s -> request to send
  ; RETURN              : #true if success or #false if failure
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure query(*this._struct,request.s)
    Protected vRet.b
    With *this
      If IsDatabase(\id)
        vRet = DatabaseQuery(\id,request)
        If Not vRet
          writeLog(*this,request,#LOG_ERROR|#LOG_QUERY)
        EndIf 
      EndIf
      ProcedureReturn vRet
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : get_error
  ; PROCESS             : get the last error after a query or update
  ; ARGUMENT            : void
  ; RETURN              : error message
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure.s get_error(*this._struct)
    With *this
      ProcedureReturn DatabaseError()
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : update
  ; PROCESS             : send a update message to database
  ; ARGUMENT            : request.s -> request to send
  ; RETURN              : #True if success or #False if failure
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure update(*this._struct,request.s)
    Protected vRet.b
    With *this
      vRet = DatabaseUpdate(\id,request)
      If Not vRet
        writeLog(*this,request,#LOG_ERROR|#LOG_UDPATE)
      Else
        writeLog(*this,request,#LOG_UDPATE)
      EndIf
      ProcedureReturn vRet
    EndWith
  EndProcedure
  
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : next_row
  ; PROCESS             : get next database row
  ; ARGUMENT            : void
  ; RETURN              : #True if next row or #False if not
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure next_row(*this._struct)
    With *this
      ProcedureReturn NextDatabaseRow(\id)
    EndWith
  EndProcedure
  
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : get_string
  ; PROCESS             : get string from current row of database
  ; ARGUMENT            : column
  ; RETURN              : string 
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure.s get_string(*this._struct,column)
    With *this
      ProcedureReturn GetDatabaseString(\id,column)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : get_long
  ; PROCESS             : get long form current row of database
  ; ARGUMENT            : column
  ; RETURN              : long
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure get_long(*this._struct,column)
    With *this
      ProcedureReturn GetDatabaseLong(\id,column)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : get_double
  ; PROCESS             : get double form current row of database
  ; ARGUMENT            : column
  ; RETURN              : double
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure.d get_double(*this._struct,column)
    With *this
      ProcedureReturn GetDatabaseDouble(\id,column)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : get_float
  ; PROCESS             : get float form current row of database
  ; ARGUMENT            : column
  ; RETURN              : float
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure.f get_float(*this._struct,column)
    With *this
      ProcedureReturn GetDatabaseFloat(\id,column)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : get_quad
  ; PROCESS             : get quad form current row of database
  ; ARGUMENT            : column
  ; RETURN              : quad
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure.q get_quad(*this._struct,column)
    With *this
      ProcedureReturn GetDatabaseQuad(\id,column)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : set_long
  ; PROCESS             : set long of request
  ; ARGUMENT            : column
  ; RETURN              : quad
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure set_long(*this._struct,column,value)
    With *this
      SetDatabaseLong(\id,column,value)
      writeLog(*this,Str(value),#LOG_SETLONG)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : set_float
  ; PROCESS             : set float of request
  ; ARGUMENT            : column,value
  ; RETURN              : void
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure set_float(*this._struct,column,value.f)
    With *this
      SetDatabaseFloat(\id,column,value)
      writeLog(*this,StrF(value),#LOG_SETFLOAT)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : set_double
  ; PROCESS             : set double of request
  ; ARGUMENT            : column,value.d
  ; RETURN              : void
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure set_double(*this._struct,column,value.d)
    With *this
      SetDatabaseDouble(\id,column,value)
      writeLog(*this,StrD(value),#LOG_SETDOUBLE)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : set_quad
  ; PROCESS             : set quad of request
  ; ARGUMENT            : column,value.q
  ; RETURN              : void
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure set_quad(*this._struct,column,value.q)
    With *this
      SetDatabaseQuad(\id,column,value)
      writeLog(*this,StrD(value),#LOG_SETQUAD)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : set_string
  ; PROCESS             : set quad of request
  ; ARGUMENT            : column,value.q
  ; RETURN              : void
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure set_string(*this._struct,column,value.s)
    With *this
      SetDatabaseString(\id,column,value)
      writeLog(*this,value,#LOG_SETSTRING)
    EndWith
  EndProcedure
  ;{ --------------------------------------------------------------------------------------------------------
  ; PUBLIC METHOD       : finish_query
  ; PROCESS             : finish a query request
  ; ARGUMENT            : column
  ; RETURN              : void
  ; MAJOR VERSION       : 1
  ; MINOR VERSION       : 1
  ; NOTE                :
  ;} --------------------------------------------------------------------------------------------------------
  Procedure finish_query(*this._struct)
    With *this
      FinishDatabaseQuery(\id)
    EndWith
  EndProcedure
  
  Procedure getIdColumn(*this._struct,name.s)
    With *this
      ProcedureReturn DatabaseColumnIndex(\id,name)
    EndWith
  EndProcedure
  
  DataSection
    S_MTH:
    Data.i @open()
    Data.i @close()
    Data.i @query()
    Data.i @get_error()
    Data.i @update()
    Data.i @next_row()
    Data.i @get_string()
    Data.i @get_long()
    Data.i @get_double()
    Data.i @get_float()
    Data.i @get_quad()
    Data.i @set_long()
    Data.i @set_float()
    Data.i @set_double()
    Data.i @set_quad()
    Data.i @set_string()
    Data.i @finish_query()
    Data.i @getIdColumn()
    E_MTH:
  EndDataSection
  
  
EndModule
; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 88
; FirstLine = 69
; Folding = dAAAQVx
; EnableXP