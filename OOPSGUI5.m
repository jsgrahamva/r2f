OOPSGUI5	;WIOFO/CVW-RPC routines ;10/11/01
	;;2.0;ASISTS;**2,8,7,11,15**;Jun 03, 2002;Build 9
EDIT(RESULTS,INPUT,ARR)	;
	;  Input: INPUT - IEN^FORM where IEN = ASISTS IEN or "NEW" if user
	;                 creating a new CA7. FORM="CA1","CA2","2162" or "CA7"
	;      SENDPARM - Array with data from client, saved into File 2260. 
	; Output:  RESULTS - Array containing the results of the store/save.
	;   NOTE:  Patch 5 llh - added FILE variable based on form being
	;                        passed in so that a CA7 could also be handled.
	N IEN,FILE,FORM,DIE,DA,DR
	S IEN=$P($G(INPUT),U,1),FORM=$P($G(INPUT),U,2)
	I $G(FORM)="" S (RESULTS,RESULTS(1))="-2^No form type" Q
	S FILE=2260 I FORM="CA7" S FILE=2264
	I '$D(^OOPS(FILE,$G(IEN),0))&($G(IEN)'="NEW") D  Q
	. S (RESULTS,RESULTS(1))="-1^IEN:"_IEN_" not found in file "_FILE
	I "CA1^CA2^CA7^2162"'[FORM D  Q
	. S (RESULTS,RESULTS(1))="-2^FORM:"_FORM_" not valid, must be CA1,CA2, or 2162"
	S RESULTS(1)="UPDATE FAILED"
	I FORM="CA1" D SAVECA1
	I FORM="CA2" D SAVECA2
	;V2_P15 Moved entire subroutine SAVE2162 to OOPSGUID due to size of OOPSGUI5
	I FORM="2162" D SAVE2162^OOPSGUID
	I FORM="CA7" D SAVECA7^OOPSGUID
	Q
SAVECA1	;
	K DR S DIE="^OOPS(2260,",DA=IEN,DR=""
	S DR(1,2260,1)="53////^S X=ARR(7)"
	S DR(1,2260,2)="53.1////^S X=ARR(8)"
	S DR(1,2260,3)="60///^S X=ARR(14)"
	S DR(1,2260,4)="61///^S X=ARR(15)"
	S DR(1,2260,5)="62////^S X=ARR(16)"
	S DR(1,2260,6)="70///^S X=ARR(22)"
	S DR(1,2260,7)="73///^S X=ARR(25)"
	S DR(1,2260,8)="12///^S X=ARR(36)"
	S DR(1,2260,11)="8///^S X=ARR(39)"
	S DR(1,2260,12)="9///^S X=ARR(40)"
	S DR(1,2260,13)="10///^S X=ARR(41)"
	S DR(1,2260,14)="11///^S X=ARR(42)"
	S DR(1,2260,15)="107///^S X=ARR(43)"
	S DR(1,2260,16)="108///^S X=ARR(44)"
	S DR(1,2260,17)="109///^S X=ARR(45)"
	S DR(1,2260,18)="110///^S X=ARR(46)"
	S DR(1,2260,19)="111///^S X=ARR(47)"
	S DR(1,2260,20)="112///^S X=ARR(48)"
	S DR(1,2260,21)="113///^S X=ARR(49)"
	S DR(1,2260,22)="114///^S X=ARR(50)"
	S DR(1,2260,24)="123///^S X=ARR(60)"
	S DR(1,2260,25)="124///^S X=ARR(61)"
	S DR(1,2260,26)="126///^S X=ARR(62)"
	S DR(1,2260,27)="130///^S X=ARR(63)"
	S DR(1,2260,28)="131///^S X=ARR(64)"
	S DR(1,2260,29)="132///^S X=ARR(65)"
	S DR(1,2260,30)="133///^S X=ARR(66)"
	S DR(1,2260,31)="134///^S X=ARR(67)"
	S DR(1,2260,32)="138///^S X=ARR(70)"
	S DR(1,2260,33)="139///^S X=ARR(71)"
	S DR(1,2260,34)="140///^S X=ARR(72)"
	S DR(1,2260,35)="141///^S X=ARR(73)"
	S DR(1,2260,36)="142///^S X=ARR(74)"
	D ^DIE I '($D(Y)=0) Q
	K DR S DIE="^OOPS(2260,",DA=IEN,DR=""
	S DR(1,2260,37)="143///^S X=ARR(75)"
	S DR(1,2260,38)="144///^S X=ARR(76)"
	S DR(1,2260,39)="145///^S X=ARR(77)"
	S DR(1,2260,40)="146///^S X=ARR(78)"
	S DR(1,2260,41)="147///^S X=ARR(79)"
	S DR(1,2260,42)="148///^S X=ARR(80)"
	S DR(1,2260,43)="149///^S X=ARR(81)"
	S DR(1,2260,44)="150///^S X=ARR(82)"
	S DR(1,2260,45)="151///^S X=ARR(83)"
	S DR(1,2260,46)="152///^S X=ARR(84)"
	S DR(1,2260,47)="153///^S X=ARR(85)"
	S DR(1,2260,48)="154///^S X=ARR(86)"
	S DR(1,2260,49)="155///^S X=ARR(87)"
	S DR(1,2260,50)="156///^S X=ARR(88)"
	S DR(1,2260,51)="157///^S X=ARR(89)"
	S DR(1,2260,52)="158///^S X=ARR(90)"
	S DR(1,2260,53)="159///^S X=ARR(91)"
	S DR(1,2260,54)="160///^S X=ARR(92)"
	S DR(1,2260,55)="161///^S X=ARR(93)"
	S DR(1,2260,56)="162///^S X=ARR(94)"
	S DR(1,2260,57)="163///^S X=ARR(95)"
	S DR(1,2260,58)="165.1///^S X=ARR(96)"
	S DR(1,2260,59)="165.2///^S X=ARR(97)"
	S DR(1,2260,60)="166///^S X=ARR(98)"
	S DR(1,2260,61)="167///^S X=ARR(99)"
	S DR(1,2260,62)="168///^S X=ARR(100)"
	S DR(1,2260,63)="172///^S X=ARR(104)"
	S DR(1,2260,64)="173///^S X=ARR(105)"
	S DR(1,2260,65)="173.1///^S X=ARR(106)"
	S DR(1,2260,66)="174///^S X=ARR(107)"
	S DR(1,2260,67)="175///^S X=ARR(108)"
	S DR(1,2260,68)="176///^S X=ARR(109)"
	S DR(1,2260,69)="177///^S X=ARR(110)"
	S DR(1,2260,70)="178///^S X=ARR(111)"
	S DR(1,2260,71)="179///^S X=ARR(112)"
	S DR(1,2260,72)="180///^S X=ARR(113)"
	S DR(1,2260,73)="181///^S X=ARR(114)"
	S DR(1,2260,74)="182///^S X=ARR(115)"
	S DR(1,2260,75)="183///^S X=ARR(116)"
	S DR(1,2260,76)="184///^S X=ARR(117)"
	S DR(1,2260,77)="185///^S X=ARR(118)"
	S DR(1,2260,78)="330///^S X=ARR(119)"
	S DR(1,2260,79)="331///^S X=ARR(120)"
	S DR(1,2260,80)="332///^S X=ARR(121)"
	; patch 11 - added REASON FOR DISPUTE CODE
	S DR(1,2260,81)="347///^S X=ARR(122)"
	D ^DIE I $D(Y)=0 S RESULTS(1)="UPDATE COMPLETED"
	Q
SAVECA2	;
	K DR S DIE="^OOPS(2260,",DA=IEN,DR=""
	S DR(1,2260,1)="60///^S X=ARR(14)"
	S DR(1,2260,5)="61///^S X=ARR(15)"
	S DR(1,2260,7)="62////^S X=ARR(16)"
	S DR(1,2260,10)="70///^S X=ARR(22)"
	S DR(1,2260,15)="73///^S X=ARR(25)"
	S DR(1,2260,20)="12///^S X=ARR(38)"
	S DR(1,2260,25)="8///^S X=ARR(41)"
	S DR(1,2260,30)="9///^S X=ARR(42)"
	S DR(1,2260,35)="10///^S X=ARR(43)"
	S DR(1,2260,40)="11///^S X=ARR(44)"
	S DR(1,2260,41)="126///^S X=ARR(36)"
	S DR(1,2260,45)="207///^S X=ARR(45)"
	S DR(1,2260,50)="208///^S X=ARR(46)"
	S DR(1,2260,55)="209///^S X=ARR(47)"
	S DR(1,2260,60)="210///^S X=ARR(48)"
	S DR(1,2260,65)="211///^S X=ARR(49)"
	S DR(1,2260,70)="212///^S X=ARR(50)"
	S DR(1,2260,75)="213///^S X=ARR(51)"
	S DR(1,2260,80)="214///^S X=ARR(52)"
	D ^DIE I '($D(Y)=0) Q
	K DR S DIE="^OOPS(2260,",DA=IEN,DR=""
	S DR(1,2260,85)="215///^S X=ARR(53)"
	S DR(1,2260,90)="225///^S X=ARR(57)"
	S DR(1,2260,95)="226///^S X=ARR(58)"
	S DR(1,2260,100)="227///^S X=ARR(59)"
	S DR(1,2260,105)="230///^S X=ARR(60)"
	S DR(1,2260,110)="231///^S X=ARR(61)"
	S DR(1,2260,115)="232///^S X=ARR(62)"
	S DR(1,2260,120)="233///^S X=ARR(63)"
	S DR(1,2260,125)="234///^S X=ARR(64)"
	S DR(1,2260,130)="237///^S X=ARR(67)"
	S DR(1,2260,135)="238///^S X=ARR(68)"
	S DR(1,2260,140)="239///^S X=ARR(69)"
	S DR(1,2260,145)="240///^S X=ARR(70)"
	S DR(1,2260,150)="241///^S X=ARR(71)"
	S DR(1,2260,155)="242///^S X=ARR(72)"
	S DR(1,2260,160)="243///^S X=ARR(73)"
	S DR(1,2260,165)="244///^S X=ARR(74)"
	S DR(1,2260,170)="245///^S X=ARR(75)"
	S DR(1,2260,175)="246///^S X=ARR(76)"
	S DR(1,2260,180)="247///^S X=ARR(77)"
	S DR(1,2260,185)="248///^S X=ARR(78)"
	S DR(1,2260,190)="249///^S X=ARR(79)"
	S DR(1,2260,192)="250///^S X=ARR(80)"
	S DR(1,2260,195)="251///^S X=ARR(81)"
	S DR(1,2260,200)="252///^S X=ARR(82)"
	S DR(1,2260,205)="253///^S X=ARR(83)"
	D ^DIE I '($D(Y)=0) Q
	K DR S DIE="^OOPS(2260,",DA=IEN,DR=""
	S DR(1,2260,210)="254///^S X=ARR(84)"
	S DR(1,2260,215)="255///^S X=ARR(85)"
	S DR(1,2260,220)="256///^S X=ARR(86)"
	S DR(1,2260,225)="258///^S X=ARR(87)"
	S DR(1,2260,230)="259///^S X=ARR(88)"
	S DR(1,2260,235)="260///^S X=ARR(89)"
	S DR(1,2260,240)="261///^S X=ARR(90)"
	S DR(1,2260,245)="262///^S X=ARR(91)"
	S DR(1,2260,250)="263///^S X=ARR(92)"
	S DR(1,2260,255)="264///^S X=ARR(93)"
	S DR(1,2260,260)="268///^S X=ARR(97)"
	S DR(1,2260,265)="269///^S X=ARR(98)"
	S DR(1,2260,270)="269.1///^S X=ARR(99)"
	S DR(1,2260,275)="270///^S X=ARR(100)"
	; Patch 5 llh - added new fields
	S DR(1,2260,276)="330///^S X=ARR(101)"
	S DR(1,2260,277)="331///^S X=ARR(102)"
	D ^DIE I $D(Y)=0 S RESULTS(1)="UPDATE COMPLETED"
	Q
