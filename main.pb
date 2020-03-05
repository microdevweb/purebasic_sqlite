; ----------------------------------------------------
; AUTHOR  : microdevWeb
; MODULE  : sqlite
; EXAMPLE :
; ----------------------------------------------------
XIncludeFile "include/sqlite.pbi"
EnableExplicit
Macro sqlError()
  MessageRequester("SQL ERROR",req+Chr(10)+db\getError(),#PB_MessageRequester_Error)
  End
EndMacro
sqlite::FILE_PATH = "data"
sqlite::FILE_NAME = "myDase.db"
sqlite::LOG_PATH = "log"
sqlite::LOG_NAME = "sqll.log"

Procedure createDatabase()
  Protected db.sqlite::obj = sqlite::new(),
            req.s = "CREATE TABLE IF NOT EXISTS  person ("+
                    "id INTEGER PRIMARY KEY AUTOINCREMENT,"+
                    "name TEXT,"+
                    "age INTEGER)"
  
  If Not db\open():sqlError():EndIf
  If Not db\update(req):sqlError():EndIf
  db\close()
EndProcedure

Procedure fillDatabase()
  Protected db.sqlite::obj = sqlite::new(),
            req.s = "INSERT INTO person (name,age) VALUES (?,?)",
            name.s,age.s
  If Not db\open():sqlError():EndIf
  Restore D_NAME
  Repeat
    Read.s name
    If name = "-1":Break:EndIf
    Read.s age
    db\setString(0,name)
    db\setLong(1,Val(age))
    If Not db\update(req):sqlError():EndIf
    
  ForEver
  db\close()
EndProcedure

Procedure readDatabase()
  Protected db.sqlite::obj = sqlite::new(),
            req.s = "SELECT * FROM person"
  If Not db\open():sqlError():EndIf
  If Not db\query(req):sqlError():EndIf
  While db\nextRow()
    Debug db\getString(db\getIdColumn("name"))+" : "+Str(db\getLong(db\getIdColumn("age")))
  Wend
  db\close()
EndProcedure

createDatabase()
fillDatabase()
readDatabase()


; for make some records into  db
DataSection
  D_NAME: 
  Data.s "Pierre","54","Jacque","18","Olivier","30","Marcel","34","Jhon","47","George","64","Philippes","28","Fred","84","Alain","16","-1"

EndDataSection

; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 21
; FirstLine = 3
; Folding = -
; EnableXP