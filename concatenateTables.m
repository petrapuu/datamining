%importataan cleanData, finalMech ja categories.csv:t
cleanData(1,:) = [];
categories(28948:end,:) = [];

%poistetaan sarakkeita tarkastelun kannalta turhina!
cleanData = removevars(cleanData, {'suggested1player','suggested2player','suggested3player','suggested4player','suggested5player','suggested6player','suggested7player','suggested8player','suggested9player','suggested10player','suggestedOver10player','suggestedPlayerAge'});
cleanData = removevars(cleanData, 'publisher');

%poistetaan sarakkeet ja korvataan tehdyill‰ tauluilla (joista poistettu
%turhat otsakesarakkeet)
cleanData = removevars(cleanData, {'category','mechanic'});
table = [cleanData finalMech];
table = [table categories];

% nimet‰‰n mekaniikkasarakkeet uudelleen
table.Properties.VariableNames{15} = 'mActionMovementProgramming';
table.Properties.VariableNames{16} = 'mActionPointAllowanceSystem';
table.Properties.VariableNames{17} = 'mAreaControlAreaInfluence';
table.Properties.VariableNames{18} = 'mAreaEnclosure';
table.Properties.VariableNames{19} = 'mAreaMovement';
table.Properties.VariableNames{20} = 'mAreaImpulse';
table.Properties.VariableNames{21} = 'mCampaignBattleCardDriven';
table.Properties.VariableNames{22} = 'mCardDrafting';
table.Properties.VariableNames{23} = 'mChitPullSystem';
table.Properties.VariableNames{24} = 'mDeckPoolBuilding';
table.Properties.VariableNames{25} = 'mDiceRolling';
table.Properties.VariableNames{26} = 'mGridMovement';
table.Properties.VariableNames{27} = 'mHandManagement';
table.Properties.VariableNames{28} = 'mHexAndCounter';
table.Properties.VariableNames{29} = 'mLineDrawing';
table.Properties.VariableNames{30} = 'mBusiness';
table.Properties.VariableNames{31} = 'mCoOp';
table.Properties.VariableNames{32} = 'mPatternGames';
table.Properties.VariableNames{33} = 'mRouteGames';
table.Properties.VariableNames{34} = 'mSocial';
table.Properties.VariableNames{35} = 'mMemory';
table.Properties.VariableNames{36} = 'mModularBoard';
table.Properties.VariableNames{37} = 'mPaperAndPencil';
table.Properties.VariableNames{38} = 'mPickUpAndDeliver';
table.Properties.VariableNames{39} = 'mPlayerElimination';
table.Properties.VariableNames{40} = 'mPointToPointMovement';
table.Properties.VariableNames{41} = 'mPressYourLuck';
table.Properties.VariableNames{42} = 'mRockPaperScissors';
table.Properties.VariableNames{43} = 'mRollSpinAndMove';
table.Properties.VariableNames{44} = 'mSecretUnitDeployment';
table.Properties.VariableNames{45} = 'mSetCollection';
table.Properties.VariableNames{46} = 'mSimulation';
table.Properties.VariableNames{47} = 'mSimultaneousActionSelection';
table.Properties.VariableNames{48} = 'mTilePlacement';
table.Properties.VariableNames{49} = 'mTrading';
table.Properties.VariableNames{50} = 'mVariablePhaseOrder';
table.Properties.VariableNames{51} = 'mVariablePlayerPowers';
table.Properties.VariableNames{52} = 'mVoting';
table.Properties.VariableNames{53} = 'mWorkerPlacement';
table = removevars(table, {'numberofweights','owned'});

%muokataan langdepit numeerisiksi arvoiksi
cell = table2cell(table);
cellLangDep = num2cell(cell(:,12));
cellLangDep=[cellLangDep{:}];
stringLangDep = string(cellLangDep)
stringLangDep = stringLangDep';
stringLangDep = replace(stringLangDep,{'No'},'0.25');
stringLangDep = replace(stringLangDep,{'Some'},'0.5');
stringLangDep = replace(stringLangDep,{'Moderate'},'0.75');
stringLangDep = replace(stringLangDep,{'Extensive'},'1');
stringLangDep = replace(stringLangDep,{'Unplayable'},'0');
stringLangDep = replace(stringLangDep,{'null'},'0.5');
stringLangDep = str2double(stringLangDep);
langdepTable = array2table(stringLangDep);
langdepTable.Properties.VariableNames{1} = 'langdep';
table.langdep = langdepTable.langdep;