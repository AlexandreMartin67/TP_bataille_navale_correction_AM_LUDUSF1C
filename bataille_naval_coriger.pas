PROGRAM bataille_naval;

uses crt;

Const
	NB_BATEAUX = 3;
	MAX_CASE = 5;
	MIN_LIGNE = 1;
	MAX_LIGNE = 50;
	MIN_COL = 1;
	MAX_COL = 50;

Type
	cases = record
		ligne : integer;
		col : integer;
	End;

Type
	bateau = record
		ncase : array[1..MAX_CASE] of cases;
	End;

Type
	flotte = record
		nbateau : array[1..NB_BATEAUX] of bateau;
	End;

Type
	Position_Bateau = (enligne,encolonne,endiag);

Type
	Etat_Bateau = (toucher,couler);

Type
	Etat_Flotte = (aFlot,aSombrer);

Type
	Etat_Joueur = (gagne ,perd);

procedure creat_Cases (l,c :integer ; var mcase : cases);
//But : permet de crée une case
//Entrée : une ligne et une colonne
//Sortie : une case completer

	Begin
		mcase.ligne := l;
		mcase.col := c;
	End;

function comp_Cases (mcase,tcase :cases) : boolean;
//But : permet de comparer deux case
//Entrée : deux case 
//Sortie : envoie un booleen vrai si les deux case son identique

	Begin
		if (mcase.col = tcase.col) and (mcase.ligne = tcase.ligne) Then
			comp_Cases := true
		else
			comp_Cases := false;
	End;

function creat_Bateau (var mcase : cases ; taille:integer) : bateau;
//But : permet de crée un bateau
//Entrée : une case et la taille du bateau
//Sortie : une variable de type bateau

	var
		resultat_bateau : bateau;
		posBateau : Position_Bateau;
		pos,i : integer;

	Begin
		pos := random(3);
		posBateau := Position_Bateau(pos);
		For i:=1 TO MAX_CASE DO
			Begin
				If (i<=taille) then
					Begin
						resultat_bateau.ncase[i].ligne := mcase.ligne;
						resultat_bateau.ncase[i].col := mcase.col;
					End
				Else
					Begin
						resultat_bateau.ncase[i].ligne := 0;
						resultat_bateau.ncase[i].col := 0;
					End;
				If (PosBateau =enligne) THEN
					mcase.col:= mcase.col+1
				Else If (PosBateau =encolonne) THEN
					mcase.ligne:= mcase.ligne+1
					Else If (PosBateau =endiag) THEN
						Begin
							mcase.ligne:= mcase.ligne+1;
							mcase.col:= mcase.col+1;
						End;
			End;
		creat_Bateau := resultat_bateau
	End;

function controle_case(mbat:bateau ; mcase:cases):boolean;
//But : permet de comparer toute les cases d'un bateau
//Entrée : un bateau et une case
//Sortie : envoie un booleen vrai si une des cases est identique

	VAR
		i:integer;
		val_test : boolean;

	Begin
		val_test := false;
		FOR i:=1 to MAX_CASE do
			If(comp_Cases(mbat.ncase[i],mcase)) THEN
				val_test := true;
		controle_case := val_test;
	End;

function controle_flotte (mFlotte1,mFlotte2: flotte ; mcase:cases) : boolean;
//But : permet de comparer toute les cases de tout les bateau 
//Entrée : une flotte bateau et une case
//Sortie : envoie un booleen vrai si une des cases est identique
	
	VAR
		i:integer;
		val_test : boolean;

	Begin
		val_test := false;
		FOR i:=1 to NB_BATEAUX do
			Begin
				If(controle_case(mFlotte1.nbateau[i],mcase)) OR (controle_case(mFlotte2.nbateau[i],mcase))  THEN
					val_test := true;
                        End;
		controle_flotte := val_test;
	End;

procedure init_flotte_player1 (var mFlotte1,mFlotte2:flotte ;var mcase:cases);
//But : crée tous les bateau du joueur 1
//Entrée : une flotte bateau et une case
//Sortie : tous les bateaux du joueur 1

	VAR
		l,c,i,taille:integer;

	Begin
		Repeat
			FOR i:=1 to NB_BATEAUX do
				Begin
					taille:=random(MAX_CASE)+1;
					l:=random(MAX_LIGNE-taille)+1 ;
					c:=random(MAX_COL-taille)+1 ;
					creat_Cases (l,c,mcase);
					mFlotte1.nbateau[i]:=creat_Bateau(mcase,taille);
				End;	
		Until (controle_flotte(mFlotte1,mFlotte2,mcase)=false);
	End;

procedure init_flotte_player2 (var mFlotte1,mFlotte2:flotte ;var mcase:cases);
//But : crée tous les bateau du joueur 2
//Entrée : une flotte bateau et une case
//Sortie : tous les bateaux du joueur 2

	VAR
		l,c,i,taille:integer;

	Begin
		Repeat
			FOR i:=1 to NB_BATEAUX do
				Begin
					taille:=random(MAX_CASE)+1;
					l:=random(MAX_LIGNE-taille)+1 ;
					c:=random(MAX_COL-taille)+1 ;
					mFlotte2.nbateau[i]:=creat_Bateau(mcase,taille);
				End;	
		Until (controle_flotte(mFlotte1,mFlotte2,mcase)=false);
	End;

procedure affichage_player1debug (mFlotte2:flotte);
//But : affiche les bateaux de l'ennemi (mode debug)
//Entrée : la flotte de bateaux du joueur 2
//Sortie : affichage des bateaux

	VAR
		i,j:integer;
	Begin
		FOR i:=1 to NB_BATEAUX do
			Begin
				writeln('bateau',i);
				FOR j:=1 to MAX_CASE do
					Begin
						writeln('ligne : ',mFlotte2.nbateau[i].ncase[j].ligne ,'/ col : ',mFlotte2.nbateau[i].ncase[j].col);
					End;	
			End;
	End;

procedure affichage_player2debug (mFlotte1:flotte);
//But : affiche les bateaux de l'ennemi (mode debug)
//Entrée : la flotte de bateaux du joueur 1
//Sortie : affichage des bateaux

	VAR
		i,j:integer;
	Begin
		FOR i:=1 to NB_BATEAUX do
			Begin
				writeln('bateau',i);
				FOR j:=1 to MAX_CASE do
					Begin
						writeln('ligne : ',mFlotte1.nbateau[i].ncase[j].ligne ,'/ col : ',mFlotte1.nbateau[i].ncase[j].col);
					End;	
			End;
	End;

procedure tir1 (var mFlotte2:flotte);
//But : permet de tirer sur les bateaux adverse 
//Entrée : la flotte de bateaux du joueur 2
//Sortie : affiche si le tire est réussi

	VAR
		i,j,cible_col,cible_ligne : integer;
		val_test : boolean;

	Begin
		writeln('entrer la ligne de votre cible');
		readln(cible_ligne);
		writeln('entrer la colonne de votre cible');
		readln(cible_col);
		val_test:=false;
		FOR i:=1 to NB_BATEAUX do
			Begin
				FOR j:=1 to MAX_CASE do
					Begin
						if(mFlotte2.nbateau[i].ncase[j].ligne = cible_ligne) AND (mFlotte2.nbateau[i].ncase[j].col = cible_col) Then
							Begin
								mFlotte2.nbateau[i].ncase[j].ligne := 0;
								mFlotte2.nbateau[i].ncase[j].col := 0;
								writeln('le tire est réussi');
								val_test:=true;
							End;
					End;	
			End;
		if(val_test = false)then
			writeln('votre tire rate sa cible');
		readln;
	End;

procedure tir2 (var mFlotte1:flotte);
//But : permet de tirer sur les bateaux adverse 
//Entrée : la flotte de bateaux du joueur 1
//Sortie : affiche si le tire est réussi

	VAR
		i,j,cible_col,cible_ligne : integer;
		val_test : boolean;

	Begin
		writeln('entrer la ligne de votre cible');
		readln(cible_ligne);
		writeln('entrer la colonne de votre cible');
		readln(cible_col);
		val_test:=false;
		FOR i:=1 to NB_BATEAUX do
			Begin
				FOR j:=1 to MAX_CASE do
					Begin
						if(mFlotte1.nbateau[i].ncase[j].ligne = cible_ligne) AND (mFlotte1.nbateau[i].ncase[j].col = cible_col) Then
							Begin
								mFlotte1.nbateau[i].ncase[j].ligne := 0;
								mFlotte1.nbateau[i].ncase[j].col := 0;
								writeln('le tire est réussi');
								val_test:=true;
							End;
					End;	
			End;
		if(val_test = false)then
			writeln('votre tire rate sa cible');
		readln;
	End;

function victoire1 (mFlotte2:flotte ):boolean;
//But : permet de savoir si le joueur 1 a gagner
//Entrée : la flotte de bateaux du joueur 2
//Sortie : renvoie un vrai si le joueur 2 n'a plus de bateau

	VAR
		i,j:integer;
		win:boolean;
	Begin
		win:=true;
		FOR i:=1 to NB_BATEAUX do
			Begin
				FOR j:=1 to MAX_CASE do
					Begin
						if(mFlotte2.nbateau[i].ncase[j].ligne <> 0) AND (mFlotte2.nbateau[i].ncase[j].col <> 0) Then
							win:=false;
					End;	
			End;
		victoire1:=win;
	End;

function victoire2 (mFlotte1:flotte ):boolean;
//But : permet de savoir si le joueur 2 a gagner
//Entrée : la flotte de bateaux du joueur 1
//Sortie : renvoie un vrai si le joueur 1 n'a plus de bateau

	VAR
		i,j:integer;
		win:boolean;
	Begin
		win:=true;
		FOR i:=1 to NB_BATEAUX do
			Begin
				FOR j:=1 to MAX_CASE do
					Begin
						if(mFlotte1.nbateau[i].ncase[j].ligne <> 0) AND (mFlotte1.nbateau[i].ncase[j].col <> 0) Then
							win:=false;
					End;	
			End;
		victoire2:=win;
	End;

//But : Crée une bataille naval
//Entrée : deux flotte de bateaux
//Sortie : un message de victoire 

VAR
	mcase , tcase : cases;
	mFlotte1 :flotte;
	mFlotte2 :flotte;

Begin
	randomize;
	clrscr;
	writeln('création de la flotte du joueur 1 ...'); 
	init_flotte_player1(mFlotte1,mFlotte2, mcase);
	readln;
	writeln('création de la flotte du joueur 2 ...');
	init_flotte_player2(mFlotte1,mFlotte2 , mcase);
	readln;
	Repeat
		clrscr;
		affichage_player1debug(mFlotte2); // affichage debug
		tir1(mFlotte2);
		If(victoire1(mFlotte2))Then
			Begin
				clrscr;
				affichage_player2debug(mFlotte1); // affichage debug
				tir2(mFlotte1);
			End;
	Until ((victoire1(mFlotte2)) or (victoire2(mFlotte1)));
	clrscr;
	If (victoire1(mFlotte2)) Then
		writeln('le joueur 1 gagne la partie')
	Else
		writeln('le joueur 2 gagne la partie');
	readln;

End.

