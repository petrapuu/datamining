% for this to work the sqlite JDBC driver has to be installed
% guide for this:
% 1) download driver from https://bitbucket.org/xerial/sqlite-jdbc/downloads/
% 2) check prefdir for matlab by running command prefdir in Command Window
% 3) close MATLAB
% 4) copy the driver jar-file in your prefered location
% 5) create file 'javaclasspath.txt' in your prefdir
% 6) write the full path to the driver jar to the javaclasspath.txt and
% save and close it
% 7) restart MATLAB

dbtype='';
username='';
pwd='';
driver='org.sqlite.JDBC';
% you need to change correct url for your data this assumes that the file
% is in the root of D-drive
URL='jdbc:sqlite:C:\Users\petra\OneDrive\Documents\Opiskelu\Kurssit\Datamining\Project\database.sqlite\database.sqlite';

conn=database(dbtype,username,pwd,driver,URL);

%the naming convention in the database was horrible, thus need to use
%multiple quotations and change between strings and char-vectors
tables = ["'bgg.ldaOut.top.documents'" "'bgg.ldaOut.top.terms'" "'bgg.topics'" "'bgg.ldaOut.topics'"]
for table=tables
    tablename=char(table);
    sqlquery = ['DROP TABLE ' tablename ];
    curs=exec(conn,sqlquery);
end

%siivotaan vähän dataa

%poistetaan laajennukset
sqlquery = 'DELETE FROM "BoardGames" WHERE "game.type" LIKE "boardgameexpansion"';
curs=exec(conn,sqlquery);

%poistetaan kokoelmat
sqlquery = 'DELETE FROM "BoardGames" WHERE "attributes.boardgamecompilation" IS NOT NULL';
curs=exec(conn,sqlquery);

%poistetaan pelit joilla ei ole paljon arvioita
sqlquery = 'DELETE FROM "BoardGames" WHERE "stats.usersrated" < 5';
curs=exec(conn,sqlquery);

%header kiinnostaville sarakkeille
header={'name' 'maxplayers' 'minage' 'minplayers' 'minplaytime' 'playtime' ...
    'yearpublished' 'category' 'mechanic' 'publisher' 'average' 'weightaverage' ...
    'numberofweights' 'owned' 'position' 'usersrated' 'langdep' 'suggested1player' ...
    'suggested2player' 'suggested3player' 'suggested4player' 'suggested5player'...
     'suggested6player' 'suggested7player' 'suggested8player' 'suggested9player'...
      'suggested10player' 'suggestedOver10player' 'suggestedPlayerAge'};

% sql-lause jolla haetaan kiinnostavat sarakkeet
sqlquery = ['SELECT "details.name","details.maxplayers","details.minage","details.minplayers",' ...
'"details.minplaytime","details.playingtime","details.yearpublished","attributes.boardgamecategory" '...
',"attributes.boardgamemechanic","attributes.boardgamepublisher","stats.average",'...
'"stats.averageweight","stats.numweights","stats.owned","stats.subtype.boardgame.pos",'...
'"stats.usersrated","polls.language_dependence","polls.suggested_numplayers.1",'...
'"polls.suggested_numplayers.2","polls.suggested_numplayers.3","polls.suggested_numplayers.4",'...
'"polls.suggested_numplayers.5","polls.suggested_numplayers.6","polls.suggested_numplayers.7",'...
'"polls.suggested_numplayers.8","polls.suggested_numplayers.9","polls.suggested_numplayers.10",'...
'"polls.suggested_numplayers.Over","polls.suggested_playerage" FROM "BoardGames"'];

%haku
results=fetch(conn,sqlquery);

% tulokset tauluun headerilla jotta myöhemmin helpompi käsitellä ja tietää
% kunkin sarakkeen merityksen
resultTable=cell2table(results,'VariableNames',header);

% talletetaan tieto csv-muotoon
writetable(resultTable,'cleanData.csv');