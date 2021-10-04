VWREGPI	; VEN/SMH - VW MU REG 2.0 Post-install ; 11/5/12 12:51pm
	;;2.0;VW MU REG;;Nov 05, 2012;Build 18
	; Enter VW Local Registration Template into Site Parameters
	; PEPs: POST
	;
POST	; Post install hook
	N DIE,DA,DR
	S DIE="^DG(43,",DA=1,DR="70///VW LOCAL REGISTRATION TEMPLATE"
	D ^DIE
	QUIT
