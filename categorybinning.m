% importtaa cleandata tai tuo se muutoin workspaceen

% otetaan kategoriasarake cleanDatasta ja tehd‰‰n siit‰ cell array
categories = cleanData(:,8);
categories.category = cellstr(categories.category);
categories = table2cell(categories);

% tehd‰‰n kategorioiden yhdistelyt tulevien sarakem‰‰rien v‰hent‰miseksi
categories = replace(categories,{'Travel', 'Pirates'},'Adventure');
categories = replace(categories,{'Ancient', 'Age of Reason', 'Medieval', 'Napoleonic', 'Post-Napoleonic', 'Prehistoric', 'Renaissance'},'History');
categories = replace(categories,{'Deduction', 'Math', 'Maze', 'Memory', 'Number', 'Puzzle', 'Trivia'},'Intelligence');
categories = replace(categories,{'Negotiation', 'Bluffing'},'Social');
categories = replace(categories,{'American Civil War', 'American Indian Wars', 'American Revolutionary War', 'Civil War', 'Korean War', 'Modern Warfare', 'Pike and Shot', 'Vietnam War', 'Wargame', 'World War I', 'World War II'},'War');
categories = replace(categories,{'Zombies'},'Horror');
categories = replace(categories,{'Collectible Components', 'Miniatures'},'Collecting');
categories = replace(categories,{'Animals', 'Environmental', 'Farming'},'Nature');
categories = replace(categories,{'Industry / Manufacturing'},'Economic');
categories = replace(categories,{'Aviation / Flight', 'Nautical', 'Trains'},'Transportation');
categories = replace(categories,{'Comic Book / Strip', 'Movies / TV / Radio theme', 'Music', 'Novel-based', 'Video Game Theme'},'Entertainment');
categories = replace(categories,{'Racing'},'Sports');
categories = replace(categories,{'Science Fiction', 'Space Exploration'},'Scifi');
categories = replace(categories,{'Mafia', 'Murder/Mystery', 'Spies/Secret Agents'},'Crime');
categories = replace(categories,{'Civilization', 'Political'},'Society');
categories = replace(categories,{'American West', 'Arabian', 'Medical'},'Others');
categories = replace(categories,{'Mythology', 'Religious'},'Myths and Religions');
categories = replace(categories,{'City Building', 'Territory Building'},'Building');
categories = replace(categories,{'Expansion for Base-game', 'Fan Expansion', 'Game System', 'null'},'');
categories = replace(categories,{'WarI'},'War');

% etsit‰‰n mit‰ kaikkia kategorioita j‰‰ j‰ljelle, jotta n‰ist‰ saadaan
% muodostettua oma rivins‰ taulukkoon bin‰‰riarvoja varten.
splittedCategories = regexp( categories, ',', 'split');
splittedInOwnCells = horzcat(splittedCategories{:});
listOfCategories = unique(splittedInOwnCells);
% poistetaan listOfCategoriesista categories-otsikkoa vastaava sarake
listOfCategories(:,37) = [];

% kopioidaan listOfCategories categories-taulukon ensimm‰iseksi riviksi
% bin‰‰riarvoja varten
categories(1,2:36) = listOfCategories(1,2:36);

% t‰ytet‰‰n kaikki tyhj‰t sarakkeet samalla arvolla, jotta niit‰ pystyt‰‰n
% muokkaamaan j‰lkik‰teen. T‰ss‰ k‰ytetty arvoa 'e' (=empty).
tf = cellfun('isempty',categories);
categories(tf) = {'e'}; 

% Poistetaan hipsu Children's Gamesta jatkon helpottamiseksi
% categories(1,8) = 'Childrens Games';

% asetetaan sarakkeille bin‰‰riarvot
for i = 2:36
    categories(:,i) = num2cell(~cellfun(@isempty, strfind(categories(:,1), categories(1,i))));
    categories(1,i) = listOfCategories(1,i);
end

% muutetaan tauluksi
categorytable = cell2table(categories);
categorytable.Properties.VariableNames = {'categories', 'cAbstractStrategy','cActionDexterity', 'cAdventure', 'cBook', 'cBuilding', 'cCardGame', 'cChildrensGame', 'cCollecting', 'cCrime', 'cDice', 'cEconomic', 'cEducational', 'cElectronic', 'cEntertainment', 'cExploration', 'cFantasy', 'cFighting', 'cHistory', 'cHorror', 'cHumor', 'cIntelligence', 'cMatureAdult', 'cMythsAndReligions', 'cNature', 'cOthers', 'cPartyGame', 'cPrintAndPlay', 'cRealTime', 'cScifi', 'cSocial', 'cSociety', 'cSports', 'cTransportation', 'cWar', 'cWordGame'}

% war ja transportation omiksi tauluikseen
categorytable1 = categorytable(:,34);
categorytable2 = categorytable(:,35);

%poistetaan otsikkosarakkeet
categorytable1(1,:) = [];
categorytable2(1,:) = [];
categorytable(1,:) = [];

% muutetaan transportation ja war tablet arrayksi looppia varten
categorytable1=table2array(categorytable1);
categorytable2=table2array(categorytable2);

% muutetaan Transportationin ykkˆnen nollaksi, jos saman pelin kohdalla warilla on arvo 1
for i = 1:28947
    if (isequal(categorytable1{i}, categorytable2{i})) && (isequal(categorytable1{i}, 1)) 
        categorytable1{i} = 0;
    end
end

% takaisin tauluksi
categorytable1 = cell2table(categorytable1);

categorytable1.Properties.VariableNames = {'cTransportation'};
categorytable1.cTransportation = num2cell(categorytable1.cTransportation);
% categorytable = removevars(categorytable, 'cTransportation');

categorytable.cTransportation = categorytable1.cTransportation;

writetable(categorytable,'categorytable.csv');