GMTSDGC2	; SLC/SBW,KER - Extended ADT Hist (cont) ;06/25/15  15:48
	;;2.7;Health Summary;**28,49,71,101,111**;Oct 20, 1995;Build 17
	;
	; External References
	;   ICR  1372  ^DGPT(
	;   ICR  5699  $$ICDDATA^ICDXCODE
	;
ICDP(DFN,PTF)	; Module For History of PTF Procedures
	Q:'$D(^DGPT(PTF,"P"))
	N II,PRX,X,IX,GMP,GTA,O,O1,LN1,GMTSTAB
	S II=0,GMTSTAB="  "
	F  S II=$O(^DGPT(PTF,"P",II)) Q:'II  S PRX=^DGPT(PTF,"P",II,0)_U_$G(^DGPT(PTF,"P",II,1)),X=$P(PRX,U,1),IX=9999999-X D REGDT4^GMTSU D
	. N GMTSDATE,GMTSTEMP S GMTSDATE=$P(^DGPT(PTF,70),U)
	. S GMP(IX)="Procedure "_X F GTA=5:1:30 D
	. . N ICDP,ICDI,ICDX Q:$P(PRX,U,GTA)=""
	. . S ICDI=+($P(PRX,U,GTA)) Q:+ICDI'>0
	. . S ICDX=$$CODESYS^GMTSPXU1(ICDI,80.1)
	. . I $P($G(ICDX),U)=-1 S GMP(IX,GTA)=$J(" ",38)_$P($G(ICDX),"^",2) Q
	. . S ICDP(80.1,ICDI,.01)=GMTSTAB_$P(ICDX,U)_"("_$P(ICDX,U,2)_")"
	. . S GMTSTEMP=$$VLT^ICDEX(80.1,ICDI,$G(GMTSDATE))
	. . S ICDP(80.1,ICDI,4)=GMTSTEMP
	. . I $D(ICDP(80.1,ICDI)) D
	. . . S GMP(IX,GTA)=ICDP(80.1,ICDI,4)_U_ICDP(80.1,ICDI,.01)
	I $D(GMP) S O=0 F  S O=$O(GMP(O)) Q:O=""  D
	. S O1=0,LN1=1
	. F  S O1=$O(GMP(O,O1)) Q:O1=""  D CKP^GMTSUP Q:$D(GMTSQIT)  S:GMTSNPG LN1=1 W:LN1 ?2,GMP(O) W ?23,$P(GMP(O,O1),U),?61,$P(GMP(O,O1),U,2),! S LN1=0
	Q
ICDS(DFN,PTF)	; Module for history of PTF surgery episodes
	Q:'$D(^DGPT(PTF,"S"))
	N II,SURG,X,IX,GMS,GMA,O,O1,LN1,GMTSTAB
	S II=0,GMTSTAB="  "
	F  S II=$O(^DGPT(PTF,"S",II)) Q:'II  S SURG=^DGPT(PTF,"S",II,0)_U_$G(^DGPT(PTF,"S",II,1)),X=$P(SURG,U,1),IX=9999999-X D REGDT4^GMTSU D
	. N GMTSDATE,GMTSTEMP S GMTSDATE=$P(^DGPT(PTF,70),U)
	. ;   Load Surgery entries into GMS array in inverted sequence
	. S GMS(IX)="  Surgery "_X F GMA=8:1:32 D
	. . ;   Surgery Line
	. . N ICDS,ICDI,ICDX
	. . S ICDI=+($P(SURG,U,GMA)) Q:+ICDI'>0
	. . S ICDX=$$CODESYS^GMTSPXU1(ICDI,80.1)
	. . I $P($G(ICDX),U)=-1 S GMS(IX,GMA)=$J(" ",38)_$P($G(ICDX),U,2) Q
	. . S ICDS(80.1,ICDI,.01)=GMTSTAB_$P(ICDX,U)_"("_$P(ICDX,U,2)_")"
	. . S GMTSTEMP=$$VLT^ICDEX(80.1,ICDI,$G(GMTSDATE))
	. . S ICDS(80.1,ICDI,4)=GMTSTEMP
	. . I $D(ICDS(80.1,ICDI)) S GMS(IX,GMA)=ICDS(80.1,ICDI,4)_U_ICDS(80.1,ICDI,.01)
	I $D(GMS) S O=0 F  S O=$O(GMS(O)) Q:O=""  D
	. S O1=0,LN1=1
	. F  S O1=$O(GMS(O,O1)) Q:O1=""  D CKP^GMTSUP Q:$D(GMTSQIT)  S:GMTSNPG LN1=1 W:LN1 ?2,GMS(O) W ?23,$P(GMS(O,O1),U),?61,$P(GMS(O,O1),U,2),! S LN1=0
	Q
