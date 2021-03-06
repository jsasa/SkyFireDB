@ECHO OFF
TITLE Database Installation Tool
COLOR 0A

:TOP
CLS
ECHO.
ECHO          浜様様様様様様様様様様様様様様様融
ECHO          �                                �
ECHO          �        Welcome to the DB       �
ECHO          �      SkyFireDB 406a Rev 92     �
ECHO          �        Installation Tool       �
ECHO          �                                �
ECHO          藩様様様様様様様様様様様様様様様夕
ECHO.
ECHO.
ECHO    Please enter your MySQL Info...
ECHO.
SET /p host= MySQL Server Address (e.g. localhost):
ECHO.
SET /p user= MySQL Username: 
SET /p pass= MySQL Password: 
ECHO.
SET /p world_db= World Database: 
SET port=3306
SET dumppath=.\dump\
SET mysqlpath=.\mysql\
SET devsql=..\MainDB\dev\
SET changsql=..\Updates
SET local_sp=\MainDB\locals\Spanish\
SET local_gr=\MainDB\locals\German\
SET local_ru=\MainDB\locals\Russian\
SER local_it=\MainDB\locals\Italian\

:Begin
CLS
SET v=""
ECHO.
ECHO.
ECHO    1 - Install 4.0.6a World Database and all updates, NOTE! Whole db will be overwritten!
ECHO.
ECHO    L - Apply Locals, "You need to install the database and updates first."
ECHO.
ECHO    W - Backup World Database.
ECHO    C - Backup Character Database.
ECHO    U - Import Changeset.
ECHO.
ECHO    S - Change your settings
ECHO.
ECHO    X - Exit this tool
ECHO.
SET /p v= 		Enter a char: 
IF %v%==* GOTO error
IF %v%==1 GOTO importDB
IF %v%==l GOTO locals
IF %v%==L GOTO locals
IF %v%==a GOTO 406sets
IF %v%==A GOTO 406sets
IF %v%==w GOTO dumpworld
IF %v%==W GOTO dumpworld
IF %v%==c GOTO dumpchar
IF %v%==C GOTO dumpchar
IF %v%==u GOTO changeset
IF %v%==U GOTO changeset
IF %v%==s GOTO top
IF %v%==S GOTO top
IF %v%==x GOTO exit
IF %v%==X GOTO exit
IF %v%=="" GOTO exit
GOTO error

:importDB
CLS
ECHO First Lets Create database (or overwrite old) !!
ECHO.
ECHO DROP database IF EXISTS `%world_db%`; > %devsql%\databaseclean.sql
ECHO CREATE database IF NOT EXISTS `%world_db%`; >> %devsql%\databaseclean.sql
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% < %devsql%\databaseclean.sql
@DEL %devsql%\databaseclean.sql

ECHO Lets make a clean database.
ECHO Importing Data now...
ECHO.
FOR %%C IN (%devsql%\*.sql) DO (
	ECHO Importing: %%~nxC
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO Successfully imported %%~nxC
)
ECHO.
ECHO import: Changesets
for %%C in (%changsql%\*.sql) do (
	ECHO import: %%~nxC
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
)
ECHO Changesets imported sucesfully!
ECHO.
ECHO Your current 4.0.6a database is complete.
ECHO You don't need to apply any updates.
ECHO.
ECHO.
ECHO.
ECHO.
PAUSE
GOTO Begin

:dumpworld
CLS
IF NOT EXIST "%dumppath%" MKDIR %dumppath%
ECHO %world_db% Database Export started...

FOR %%a IN ("%devsql%\*.sql") DO SET /A Count+=1
setlocal enabledelayedexpansion
FOR %%C IN (%devsql%\*.sql) DO (
	SET /A Count2+=1
	ECHO Dumping [!Count2!/%Count%] %%~nC
	%mysqlpath%\mysqldump --host=%host% --user=%user% --password=%pass% --port=%port% --routines --skip-comments %world_db% %%~nC > %dumppath%\%%~nxC
)
endlocal 

ECHO  Finished ... %world_db% exported to %dumppath% folder...
PAUSE
GOTO begin

:locals
CLS
ECHO   Here is a list of locals.!!!)
ECHO.   
ECHO   Spanish        = S
ECHO   German         = G  "No Data Yet"
ECHO   Russian        = R  "No Data Yet"
ECHO   Italian        = I
ECHO.
ECHO   Return to main menu = B
ECHO.
set /p ch=      Number: 
ECHO.
IF %ch%==s GOTO install_sp
IF %ch%==S GOTO install_sp
IF %ch%==g GOTO install_gr
IF %ch%==G GOTO install_gr
IF %ch%==r GOTO install_ru
IF %ch%==R GOTO install_ru
IF %ch%==i GOTO install_it
IF %ch%==I GOTO install_it
IF %ch%==b GOTO begin
IF %ch%==B GOTO begin
IF %ch%=="" GOTO locals

:install_sp
ECHO Importing Spanish Data now...
ECHO.
FOR %%C IN (%local_sp%\*.sql) DO (
	ECHO Importing: %%~nxC1
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO Spanish Locals Successfully imported %%~nxC1
)
ECHO Done.

:install_gr
ECHO Importing German Data now...
ECHO.
FOR %%C IN (%local_sp%\*.sql) DO (
	ECHO Importing: %%~nxC1
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO German Locals Successfully imported %%~nxC1
)
ECHO Done.

:install_ru
ECHO Importing Russian Data now...
ECHO.
FOR %%C IN (%local_sp%\*.sql) DO (
	ECHO Importing: %%~nxC1
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO Russian Locals Successfully imported %%~nxC1
)
ECHO Done.

:install_it
ECHO Importing Italian Data now...
ECHO.
FOR %%C IN (%local_it%\*.sql) DO (
	ECHO Importing: %%~nxC1
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO Italian Locals Successfully imported %%~nxC1
)
ECHO Done.
:dumpchar
CLS
SET sqlname=char-%DATE:~0,3% - %DATE:~4,2%-%DATE:~7,2%-%DATE:~10,4%--%TIME:~0,2%-%TIME:~3,2%
SET /p chardb=   Enter name of your character DB:
ECHO.
IF NOT EXIST "%dumppath%" MKDIR %dumppath%
ECHO Dumping %sqlname%.sql to %dumppath%
%mysqlpath%\mysqldump -u%user% -p%pass% --result-file="%dumppath%\%sqlname%.sql" %chardb%
ECHO Done.
PAUSE
GOTO begin

:changeset
CLS
ECHO   Here is a list of changesets.!!!)
ECHO.   
ECHO   changeset 11 = 11
ECHO   changeset 12 = 12
ECHO   changeset 13 = 13
ECHO   changeset 14 = 14
ECHO   changeset 15 = 15
ECHO   changeset 16 = 16
ECHO   changeset 17 = 17
ECHO   changeset 18 = 18
ECHO   changeset 19 = 19
ECHO   changeset 20 = 20
ECHO   changeset 21 = 21
ECHO   changeset 22 = 22
ECHO   changeset 23 = 23
ECHO   changeset 24 = 24
ECHO   changeset 25 = 25
ECHO   changeset 26 = 26
ECHO   changeset 27 = 27
ECHO   changeset 28 = 28
ECHO   changeset 29 = 29
ECHO   changeset 30 = 30
ECHO   changeset 31 = 31
ECHO   changeset 32 = 32
ECHO   changeset 33 = 33
ECHO   changeset 34 = 34
ECHO   changeset 35 = 35
ECHO   changeset 36 = 36
ECHO   changeset 37 = 37
ECHO   changeset 38 = 38
ECHO   changeset 39 = 39
ECHO   changeset 40 = 40
ECHO   changeset 41 = 41
ECHO   changeset 42 = 42
ECHO   changeset 43 = 43
ECHO   changeset 44 = 44
ECHO   changeset 45 = 45
ECHO   changeset 46 = 46
ECHO   changeset 47 = 47
ECHO   changeset 48 = 48
ECHO   changeset 49 = 49
ECHO   changeset 50 = 50
ECHO   changeset 51 = 51
ECHO   changeset 52 = 52
ECHO   changeset 53 = 53
ECHO   changeset 54 = 54
ECHO   changeset 55 = 55
ECHO   changeset 56 = 56
ECHO   changeset 57 = 57
ECHO   changeset 58 = 58
ECHO   changeset 59 = 59
ECHO   changeset 60 = 60
ECHO   changeset 61 = 61
ECHO   changeset 62 = 62
ECHO   changeset 63 = 63
ECHO   changeset 64 = 64
ECHO   changeset 65 = 65
ECHO   changeset 66 = 66
ECHO   changeset 67 = 67
ECHO   changeset 68 = 68
ECHO   changeset 69 = 69
ECHO   changeset 70 = 70
ECHO   changeset 71 = 71
ECHO   changeset 72 = 72
ECHO   changeset 73 = 73
ECHO   changeset 74 = 74
ECHO   changeset 75 = 75
ECHO   changeset 76 = 76
ECHO   changeset 77 = 77
ECHO   changeset 78 = 78
ECHO   changeset 79 = 79
ECHO   changeset 80 = 80
ECHO   changeset 81 = 81
ECHO   changeset 82 = 82
ECHO   changeset 83 = 83
ECHO   changeset 84 = 84
ECHO   changeset 85 = 85
ECHO   changeset 86 = 86
ECHO   changeset 87 = 87
ECHO   changeset 88 = 88
ECHO   changeset 89 = 89
ECHO   changeset 90 = 90
ECHO   changeset 91 = 91
ECHO   changeset 92 = 92

ECHO.
ECHO   Or type in "A" to import all changesets
ECHO.
ECHO   Return to main menu = B
ECHO.
set /p ch=      Number: 
ECHO.
IF %ch%==a GOTO changesetall
IF %ch%==A GOTO changesetall
IF %ch%==11 GOTO changeset11
IF %ch%==12 GOTO changeset12
IF %ch%==13 GOTO changeset13
IF %ch%==14 GOTO changeset14
IF %ch%==15 GOTO changeset15
IF %ch%==16 GOTO changeset16
IF %ch%==17 GOTO changeset17
IF %ch%==18 GOTO changeset18
IF %ch%==19 GOTO changeset19
IF %ch%==20 GOTO changeset20
IF %ch%==21 GOTO changeset21
IF %ch%==22 GOTO changeset22
IF %ch%==23 GOTO changeset23
IF %ch%==24 GOTO changeset24
IF %ch%==25 GOTO changeset25
IF %ch%==26 GOTO changeset26
IF %ch%==27 GOTO changeset27
IF %ch%==28 GOTO changeset28
IF %ch%==29 GOTO changeset29
IF %ch%==30 GOTO changeset30
IF %ch%==31 GOTO changeset31
IF %ch%==32 GOTO changeset32
IF %ch%==33 GOTO changeset33
IF %ch%==34 GOTO changeset34
IF %ch%==35 GOTO changeset35
IF %ch%==36 GOTO changeset36
IF %ch%==37 GOTO changeset37
IF %ch%==38 GOTO changeset38
IF %ch%==39 GOTO changeset39
IF %ch%==40 GOTO changeset40
IF %ch%==41 GOTO changeset41
IF %ch%==42 GOTO changeset42
IF %ch%==43 GOTO changeset43
IF %ch%==44 GOTO changeset44
IF %ch%==45 GOTO changeset45
IF %ch%==46 GOTO changeset46
IF %ch%==47 GOTO changeset47
IF %ch%==48 GOTO changeset48
IF %ch%==49 GOTO changeset49
IF %ch%==50 GOTO changeset50
IF %ch%==51 GOTO changeset51
IF %ch%==52 GOTO changeset52
IF %ch%==53 GOTO changeset53
IF %ch%==54 GOTO changeset54
IF %ch%==55 GOTO changeset55
IF %ch%==56 GOTO changeset56
IF %ch%==57 GOTO changeset57
IF %ch%==58 GOTO changeset58
IF %ch%==59 GOTO changeset59
IF %ch%==60 GOTO changeset60
IF %ch%==61 GOTO changeset61
IF %ch%==62 GOTO changeset62
IF %ch%==63 GOTO changeset63
IF %ch%==64 GOTO changeset64
IF %ch%==65 GOTO changeset65
IF %ch%==66 GOTO changeset66
IF %ch%==67 GOTO changeset67
IF %ch%==68 GOTO changeset68
IF %ch%==69 GOTO changeset69
IF %ch%==70 GOTO changeset70
IF %ch%==71 GOTO changeset71
IF %ch%==72 GOTO changeset72
IF %ch%==73 GOTO changeset73
IF %ch%==74 GOTO changeset74
IF %ch%==75 GOTO changeset75
IF %ch%==76 GOTO changeset76
IF %ch%==77 GOTO changeset77
IF %ch%==78 GOTO changeset78
IF %ch%==79 GOTO changeset79
IF %ch%==80 GOTO changeset80
IF %ch%==81 GOTO changeset81
IF %ch%==82 GOTO changeset82
IF %ch%==83 GOTO changeset83
IF %ch%==84 GOTO changeset84
IF %ch%==85 GOTO changeset85
IF %ch%==86 GOTO changeset86
IF %ch%==87 GOTO changeset87
IF %ch%==88 GOTO changeset88
IF %ch%==89 GOTO changeset89
IF %ch%==90 GOTO changeset90
IF %ch%==91 GOTO changeset91
IF %ch%==92 GOTO changeset92
IF %ch%==b GOTO begin
IF %ch%==B GOTO begin
IF %ch%=="" GOTO changeset

:changeset11
CLS
ECHO.
ECHO import: Changeset 11
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\11_world_npc_trainer.sql
ECHO Changeset 11 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset12
CLS
ECHO.
ECHO import: Changeset 12
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\12_world_item_template.sql
ECHO Changeset 12 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset13
CLS
ECHO.
ECHO import: Changeset 13
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\13_world_creature_template.sql
ECHO Changeset 13 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset14
CLS
ECHO.
ECHO import: Changeset 14
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\14_world_creature_loot_template.sql
ECHO Changeset 14 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset15
CLS
ECHO.
ECHO import: Changeset 15
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\15_world_gameobject_template.sql
ECHO Changeset 15 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset16
CLS
ECHO.
ECHO import: Changeset 16
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\16_world_gameobject_loot_template.sql
ECHO Changeset 16 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset17
CLS
ECHO.
ECHO import: Changeset 17
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\17_world_creature_template.sql
ECHO Changeset 17 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset18
CLS
ECHO.
ECHO import: Changeset 18
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\18_world_creature_addon_template.sql
ECHO Changeset 18 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset19
CLS
ECHO.
ECHO import: Changeset 19
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\19_world_creature.sql
ECHO Changeset 19 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset20
CLS
ECHO.
ECHO import: Changeset 20
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\20_world_npc_trainer.sql
ECHO Changeset 20 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset21
CLS
ECHO.
ECHO import: Changeset 21
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\21_world_spell_linked_spell.sql
ECHO Changeset 21 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset22
CLS
ECHO.
ECHO import: Changeset 22
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\22_world_creature_template.sql
ECHO Changeset 22 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset23
CLS
ECHO.
ECHO import: Changeset 23
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\23_world_creature_template.sql
ECHO Changeset 23 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset24
CLS
ECHO.
ECHO import: Changeset 24
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\24_world_playercreateinfo_action.sql
ECHO Changeset 24 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset25
CLS
ECHO.
ECHO import: Changeset 25
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\25_world_creature_loot_template.sql
ECHO Changeset 25 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset26
CLS
ECHO.
ECHO import: Changeset 26
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\26_world_game_event.sql
ECHO Changeset 26 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset27
CLS
ECHO.
ECHO import: Changeset 27
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\27_world_npc_vendor.sql
ECHO Changeset 27 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset28
CLS
ECHO.
ECHO import: Changeset 28
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\28_item_template.sql
ECHO Changeset 28 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset29
CLS
ECHO.
ECHO import: Changeset 29
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\29_world_gameobject_template.sql
ECHO Changeset 29 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset30
CLS
ECHO.
ECHO import: Changeset 30
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\30_world_creature_ai_scripts.sql
ECHO Changeset 30 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset31
CLS
ECHO.
ECHO import: Changeset 31
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\31_world_creature_ai_scripts.sql
ECHO Changeset 31 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset32
CLS
ECHO.
ECHO import: Changeset 32
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\32_world_creature_ai_scripts.sql
ECHO Changeset 32 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset33
CLS
ECHO.
ECHO import: Changeset 33
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\33_world_creature_template.sql
ECHO Changeset 33 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset34
CLS
ECHO.
ECHO import: Changeset 34
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\34_world_creature_ai_scripts.sql
ECHO Changeset 34 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset35
CLS
ECHO.
ECHO import: Changeset 35
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\35_world_creature_template.sql
ECHO Changeset 35 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset36
CLS
ECHO.
ECHO import: Changeset 36
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\36_world_creature_template.sql
ECHO Changeset 36 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset37
CLS
ECHO.
ECHO import: Changeset 37
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\37_world_creature.sql
ECHO Changeset 37 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset38
CLS
ECHO.
ECHO import: Changeset 38
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\38_world_creature_template.sql
ECHO Changeset 38 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset39
CLS
ECHO.
ECHO import: Changeset 39
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\39_world_npc_vendor.sql
ECHO Changeset 39 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset40
CLS
ECHO.
ECHO import: Changeset 40
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\40_world_npc_vendor.sql
ECHO Changeset 40 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset41
CLS
ECHO.
ECHO import: Changeset 41
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\41_world_npc_vendor.sql
ECHO Changeset 41 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset42
CLS
ECHO.
ECHO import: Changeset 42
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\42_world_npc_vendor.sql
ECHO Changeset 42 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset43
CLS
ECHO.
ECHO import: Changeset 43
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\43_world_npc_vendor.sql
ECHO Changeset 43 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset44
CLS
ECHO.
ECHO import: Changeset 44
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\44_world_npc_vendor.sql
ECHO Changeset 44 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset45
CLS
ECHO.
ECHO import: Changeset 45
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\45_world_npc_vendor.sql
ECHO Changeset 45 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset46
CLS
ECHO.
ECHO import: Changeset 46
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\46_world_npc_vendor.sql
ECHO Changeset 46 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset47
CLS
ECHO.
ECHO import: Changeset 47
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\47_world_npc_vendor.sql
ECHO Changeset 47 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset48
CLS
ECHO.
ECHO import: Changeset 48
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\48_world_creature.sql
ECHO Changeset 48 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset49
CLS
ECHO.
ECHO import: Changeset 49
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\49_world_gameobject_loot_template.sql
ECHO Changeset 49 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset50
CLS
ECHO.
ECHO import: Changeset 50
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\50_world_gameobject.sql
ECHO Changeset 50 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset51
CLS
ECHO.
ECHO import: Changeset 51
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\51_world_gameobject_template.sql
ECHO Changeset 51 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset52
CLS
ECHO.
ECHO import: Changeset 52
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\52_world_creature_template.sql
ECHO Changeset 52 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset53
CLS
ECHO.
ECHO import: Changeset 53
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\53_world_quest_template.sql
ECHO Changeset 53 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset54
CLS
ECHO.
ECHO import: Changeset 54
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\54_world_creature_template.sql
ECHO Changeset 54 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset55
CLS
ECHO.
ECHO import: Changeset 55
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\55_world_creature_template.sql
ECHO Changeset 55 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset56
CLS
ECHO.
ECHO import: Changeset 56
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\56_world_creature_template.sql
ECHO Changeset 56 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset57
CLS
ECHO.
ECHO import: Changeset 57
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\57_world_npc_vendor.sql
ECHO Changeset 57 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset58
CLS
ECHO.
ECHO import: Changeset 58
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\58_world_npc_vendor.sql
ECHO Changeset 58 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset59
CLS
ECHO.
ECHO import: Changeset 59
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\59_world_npc_vendor.sql
ECHO Changeset 59 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset60
CLS
ECHO.
ECHO import: Changeset 60
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\60_world_npc_vendor.sql
ECHO Changeset 60 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset61
CLS
ECHO.
ECHO import: Changeset 61
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\61_world_npc_vendor.sql
ECHO Changeset 61 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset62
CLS
ECHO.
ECHO import: Changeset 62
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\62_world_npc_vendor.sql
ECHO Changeset 62 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset63
CLS
ECHO.
ECHO import: Changeset 63
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\63_world_creature.sql
ECHO Changeset 63 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset64
CLS
ECHO.
ECHO import: Changeset 64
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\64_world_creature.sql
ECHO Changeset 64 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset65
CLS
ECHO.
ECHO import: Changeset 65
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\65_world_creature_addon.sql
ECHO Changeset 65 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset66
CLS
ECHO.
ECHO import: Changeset 66
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\66_world_creature.sql
ECHO Changeset 66 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset67
CLS
ECHO.
ECHO import: Changeset 67
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\67_world_playercreateinfo_spell.sql
ECHO Changeset 67 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset68
CLS
ECHO.
ECHO import: Changeset 68
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\68_world_gameobject_template.sql
ECHO Changeset 68 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset69
CLS
ECHO.
ECHO import: Changeset 69
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\69_world_gameobject_loot_template.sql
ECHO Changeset 69 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset70
CLS
ECHO.
ECHO import: Changeset 70
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\70_world_creature_loot_template.sql
ECHO Changeset 70 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset71
CLS
ECHO.
ECHO import: Changeset 71
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\71_world_npc_vendor.sql
ECHO Changeset 71 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset72
CLS
ECHO.
ECHO import: Changeset 72
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\72_world_gameobject_loot_template.sql
ECHO Changeset 72 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset73
CLS
ECHO.
ECHO import: Changeset 73
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\73_world_item_template.sql
ECHO Changeset 73 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset74
CLS
ECHO.
ECHO import: Changeset 74
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\74_world_npc_vendor.sql
ECHO Changeset 74 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset75
CLS
ECHO.
ECHO import: Changeset 75
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\75_world_npc_vendor.sql
ECHO Changeset 75 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset76
CLS
ECHO.
ECHO import: Changeset 76
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\76_world_npc_vendor.sql
ECHO Changeset 76 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset77
CLS
ECHO.
ECHO import: Changeset 77
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\77_world_npc_vendor.sql
ECHO Changeset 77 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset78
CLS
ECHO.
ECHO import: Changeset 78
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\78_world_item_template.sql
ECHO Changeset 78 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset79
CLS
ECHO.
ECHO import: Changeset 79
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\79_world_creature_template.sql
ECHO Changeset 79 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset80
CLS
ECHO.
ECHO import: Changeset 80
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\80_world_npc_vendor.sql
ECHO Changeset 80 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset81
CLS
ECHO.
ECHO import: Changeset 81
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\81_world_gameobject_loot_template.sql
ECHO Changeset 81 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset82
CLS
ECHO.
ECHO import: Changeset 82
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\82_world_gameobject_involvedrelation.sql
ECHO Changeset 82 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset83
CLS
ECHO.
ECHO import: Changeset 83
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\83_world_gameobject_involvedrelation.sql
ECHO Changeset 83 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset84
CLS
ECHO.
ECHO import: Changeset 84
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\84_world_gameobject_loot_template.sql
ECHO Changeset 84 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset85
CLS
ECHO.
ECHO import: Changeset 85
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\85_world_gameobject_loot_template.sql
ECHO Changeset 85 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset86
CLS
ECHO.
ECHO import: Changeset 86
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\86_world_npc_vendor.sql
ECHO Changeset 86 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset87
CLS
ECHO.
ECHO import: Changeset 87
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\87_world_creature_template.sql
ECHO Changeset 87 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset88
CLS
ECHO.
ECHO import: Changeset 88
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\88_world_npc_vendor.sql
ECHO Changeset 88 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset89
CLS
ECHO.
ECHO import: Changeset 89
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\89_world_npc_vendor.sql
ECHO Changeset 89 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset90
CLS
ECHO.
ECHO import: Changeset 90
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\90_world_creature_tempate.sql
ECHO Changeset 90 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset91
CLS
ECHO.
ECHO import: Changeset 91
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\91_world_npc_vendor.sql
ECHO Changeset 91 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset92
CLS
ECHO.
ECHO import: Changeset 92
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\92_world_creature_template.sql
ECHO Changeset 92 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changesetall
CLS
ECHO.
ECHO import: Changesets
for %%C in (%changsql%\*.sql) do (
	ECHO import: %%~nxC
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
)
ECHO Changesets imported sucesfully!
ECHO.
PAUSE   
GOTO begin

:error
ECHO	Please enter a correct character.
ECHO.
PAUSE
GOTO begin

:error2
ECHO	Changeset with this number not found.
ECHO.
PAUSE
GOTO begin

:exit