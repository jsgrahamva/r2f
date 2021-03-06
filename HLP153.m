HLP153	;IRMFO-ALB/CJM -Post-Install routine;03/24/2004  14:43 ;02/14/2011
	;;1.6;HEALTH LEVEL SEVEN;**153**;Oct 13, 1995;Build 11
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
POST	N IEN,DATA
	;
	;Inactivates HL7 Monitor-Link 870
	S IEN=$O(^HLEV(776.1,"B","LINK (870) CHECKS",0))
	I IEN,$D(^HLEV(776.1,IEN,0)) S $P(^HLEV(776.1,IEN,0),"^",2)="I"
	;
	;These two entries need to be in the HLO Process Registry file.
	S IEN=$O(^HLD(779.3,"B","COUNT RECORDS",0))
	I 'IEN S DATA(.01)="COUNT RECORDS",DATA(.02)=1,IEN=$$ADD^HLOASUB1(779.3,,.DATA)
	I IEN S ^HLD(779.3,IEN,0)="COUNT RECORDS^1^0^1^1440^"_DT_".02^0^QUIT1^HLOPROC1^UPDCNTS^HLOSITE^1^0^^0",^HLD(779.3,"C",1,IEN)="" K ^HLD(779.3,"C",0,IEN)
	;
	S IEN=$O(^HLD(779.3,"B","RECOUNT ALL QUEUES",0))
	I 'IEN S DATA(.01)="RECOUNT ALL QUEUES",DATA(.02)=1,IEN=$$ADD^HLOASUB1(779.3,,.DATA)
	I IEN S ^HLD(779.3,IEN,0)="RECOUNT ALL QUEUES^1^0^1^2880^"_DT_".02^0^QUIT1^HLOPROC1^QCOUNT^HLOPROC1^1^0^^0",^HLD(779.3,"C",1,IEN)="" K ^HLD(779.3,"C",0,IEN)
	Q
