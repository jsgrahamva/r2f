LR7OSAP	;DALOI/STAFF - Silent AP rpt (compare to LRAPCUM) ;03/21/13  15:30
	;;5.2;LAB SERVICE;**121,187,230,256,259,317,350,427**;Sep 27, 1994;Build 33
	;
GET	I '$D(^LR(LRDFN,LRSS)) Q
	N FST,X
	S (A,FST)=0,LRI=LRIN
	F  S LRI=$O(^LR(LRDFN,LRSS,LRI)) Q:'LRI!(CT1>COUNT)!(LRI>LROUT)  S B=$G(^(LRI,0)),CT1=CT1+1 I B D
	. D W
	. S X="",$P(X,"=",GIOM)=""
	. D LN
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,X)
	. D LINE^LR7OSUM4
	;
	I 'FST D
	. I LRSS="SP",'$D(SUBHEAD("SURGICAL PATHOLOGY")) Q
	. I LRSS="CY",'$D(SUBHEAD("CYTOPATHOLOGY")) Q
	. I LRSS="EM",'$D(SUBHEAD("EM")) Q
	. D LINE^LR7OSUM4,LN
	. S X=GIOM/2-($L(LRAA(1))/2+5)
	. S ^TMP("LRH",$J,LRAA(1))=GCNT
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(X,CCNT,"---- "_LRAA(1)_" ----")
	. D LN
	. S ^TMP("LRC",$J,GCNT,0)="No "_$S(LRSS="SP":"Surgical Pathology",LRSS="CY":"Cytology",LRSS="EM":"EM",1:"")_" reports available for date range ..."
	Q
	;
	;
F(PIECE)	;
	;If PIECE=1, then only get 1st piece; otherwise get whole node
	I '$G(PIECE) D WRAP^LR7OSAP1("^LR("_LRDFN_","""_LRSS_""","_LRI_","_LRV_")",79) Q
	S C=0
	F  S C=$O(^LR(LRDFN,LRSS,LRI,LRV,C)) Q:'C  S X=$P(^(C,0),"^") D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,X)
	Q
	;
	;
W	; Called from above and LR7OSAP4
	N LR,LRPTR,LRMD,LRTEXT,LRV,LRW,LRX
	I 'FST D
	. D LINE^LR7OSUM4,LN
	. S X=GIOM/2-($L(LRAA(1))/2+5)
	. S ^TMP("LRH",$J,LRAA(1))=GCNT
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(X,CCNT,"---- "_LRAA(1)_" ----")
	I FST D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Next "_LRAA(1)_" Specimen...")
	S FST=1
	;
	; Check for TIU document report and use instead and quit
	D TIUCHK^LRAPUTL(.LRPTR,LRDFN,LRSS,LRI)
	I +$G(LRPTR) D  Q
	. N LRCKSUM,LRCNT,LRCNTT,LRENCRYP,LRFLG,LRHFLG,LROR,LRQUIT,LRTXT
	. D MAIN^LR7OSAP3(LRPTR)
	;
	; Display reporting lab
	I $$GET^XPAR("DIV^PKG","LR REPORTS FACILITY PRINT",1,"Q")#2 D
	. S LRX=+$G(^LR(LRDFN,LRSS,LRI,"RF"))
	. I LRX D RL^LR7OSMZU(LRX)
	;
	S Y=+B
	D D^LRU
	S LRW(1)=Y,Y=$P(B,"^",10)
	D D^LRU
	S LRW(10)=Y,Y=$P(B,"^",3)
	D D^LRU
	S LRW(3)=Y,X=$P(B,"^",2)
	D:X D^LRUA
	S LRW(2)=X,LRW(11)=$P(B,"^",11),X=$P(B,"^",4)
	D:X D^LRUA
	S LRW(4)=X,X=$P(B,"^",7)
	D:X D^LRUA
	S LRW(7)=X
	D LN
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Date Spec taken: "_LRW(1)),^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(38,CCNT,"Pathologist:"_LRW(2))
	D LN
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Date Spec rec'd: "_LRW(10)),^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(38,CCNT,$S(LRSS="SP":"Resident: ",1:"Tech: ")_LRW(4))
	D LN
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,$S($L(LRW(3)):"Date  completed: ",1:"REPORT INCOMPLETE")_LRW(3)),^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(38,CCNT,"Accession #: "_$P(B,"^",6))
	D LN
	S $P(LR("%"),"-",GIOM)=""
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Submitted by: "_$P(B,"^",5)),^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(38,CCNT,"Practitioner:"_LRW(7))
	D LN
	S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LR("%"))
	;
	I $D(^LR(LRDFN,LRSS,LRI,.1)) D
	. D LN
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Specimen: ")
	. S LRV=.1
	. D F(1)
	;
	; Don't show anymore data if not verified.
	I LRW(11)="" D  Q
	. D A,LN
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Report not verified")
	;
	I $P($G(^LR(LRDFN,LRSS,LRI,1.2,0)),"^",4) D
	. D LN
	. S LRTEXT="SUPPLEMENTARY REPORT HAS BEEN ADDED"
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(14,CCNT,"*+* "_LRTEXT_" *+*")
	. D LN
	. S LRTEXT="REFER TO BOTTOM OF REPORT"
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(19,CCNT,"*+* "_LRTEXT_" *+*")
	. D LN
	;
	I $D(^LR(LRDFN,LRSS,LRI,.2)) D
	. D LN
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Brief Clinical History:")
	. S LRV=.2 D F()
	;
	I $D(^LR(LRDFN,LRSS,LRI,.3)) D
	. D LN
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Preoperative Diagnosis:")
	. S LRV=.3 D F()
	;
	I $D(^LR(LRDFN,LRSS,LRI,.4)) D
	. D LN
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Operative Findings:")
	. S LRV=.4 D F()
	;
	I $D(^LR(LRDFN,LRSS,LRI,.5)) D
	. D LN
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Postoperative Diagnosis:")
	. S LRV=.5 D F()
	;
	D SET^LRUA
	;
	I $O(^LR(LRDFN,LRSS,LRI,1.3,0)) D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LR(69.2,.13)) I $P($G(^LR(LRDFN,LRSS,LRI,6,0)),U,4) S LR(0)=6 D MOD^LR7OSAP1
	S LRV=1.3
	D F()
	;
	I $O(^LR(LRDFN,LRSS,LRI,1,0)) D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LR(69.2,.03)) I $P($G(^LR(LRDFN,LRSS,LRI,7,0)),U,4) S LR(0)=7 D MOD^LR7OSAP1
	S LRV=1
	D F()
	;
	I $O(^LR(LRDFN,LRSS,LRI,1.1,0)) D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LR(69.2,.04)_" (Date Spec taken: "_LRW(1)_")") I $P($G(^LR(LRDFN,LRSS,LRI,4,0)),U,4) S LR(0)=4 D MOD^LR7OSAP1
	S LRV=1.1
	D F()
	;
	I $O(^LR(LRDFN,LRSS,LRI,1.4,0)) D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LR(69.2,.14)) I $P($G(^LR(LRDFN,LRSS,LRI,5,0)),U,4) S LR(0)=5 D MOD^LR7OSAP1
	S LRV=1.4
	D F()
	;
	I $O(^LR(LRDFN,LRSS,LRI,1.2,0)) D
	. D LN
	. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Supplementary Report:")
	. S C=0 F  S C=$O(^LR(LRDFN,LRSS,LRI,1.2,C)) Q:'C  D
	.. S X=^LR(LRDFN,LRSS,LRI,1.2,C,0),Y=+X,X=$P(X,U,2)
	.. ;Don't even print supp date if supp is not released
	.. Q:'X
	.. D D^LRU,LN
	.. S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,"Date: "_Y)
	.. I 'X S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(1,CCNT," not verified")
	.. I $O(^LR(LRDFN,LRSS,LRI,1.2,C,2,0)) D MODSR^LR7OSAP1
	.. D:X U
	I $D(^LR(LRDFN,LRSS,LRI,2)) D B
	;
	; DALOI/LMT - LR,427 - Removed comments from report to restore pre-LR,350 behavior
	;I $D(^LR(LRDFN,LRSS,LRI,99)) D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Comments:") S LRV=99 D F(1)
	;
	; List performing labs
	D PPL^LR7OSMZ1(LRDFN,LRSS,LRI)
	;
	Q
	;
	;
U	;
	D WRAP^LR7OSAP1("^LR("_LRDFN_","""_LRSS_""","_LRI_",1.2,"_C_",1)",79)
	Q
	;
	;
B	;
	S C=0
	F  S C=$O(^LR(LRDFN,LRSS,LRI,2,C)) Q:'C  D SP
	Q
	;
	;
SP	;
	S G=0
	F  S G=$O(^LR(LRDFN,LRSS,LRI,2,C,5,G)) Q:'G  S X=^(G,0),Y=$P(X,"^",2),E=$P(X,"^",3),E(1)=$P(X,"^")_":",E(1)=$P($P($G(LR(LRSS)),E(1),2),";") D D^LRU S T(2)=Y D WP
	Q
	;
	;
WP	;
	D LN
	S X=E(1)_" "_E_" Date: "_T(2)_" ",^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,X)
	D WRAP^LR7OSAP1("^LR("_LRDFN_","""_LRSS_""","_LRI_",2,"_C_",5,"_G_",1)",79)
	Q
	;
	;
A	;
	D WRAP^LR7OSAP1("^LR("_LRDFN_","""_LRSS_""","_LRI_",97)",79)
	Q
	;
	;
LN	;Increment the counter
	S GCNT=GCNT+1,CCNT=1
	Q
	;
	;
EN	; Get AP results
	; Called by LR7OSUM
	;
	N GIOM
	S GIOM=$G(LRGIOM)
	I GIOM="" D
	. S GIOM=$$GET^XPAR("USR^DIV^PKG","LR AP GUI REPORT RIGHT MARGIN",1,"Q")
	. I GIOM="" S GIOM=80
	;
	; Display "Printed at:" notice
	I '$O(^TMP("LRC",$J,0)),$$GET^XPAR("DIV^PKG","LR REPORTS FACILITY PRINT",1,"Q")>1 D PFAC^LR7OSMZU
	;
	I $S('$D(SUBHEAD):1,1:$D(SUBHEAD("SURGICAL PATHOLOGY"))) D SPA
	I $S('$D(SUBHEAD):1,1:$D(SUBHEAD("CYTOPATHOLOGY"))) D CY
	I $S('$D(SUBHEAD):1,1:$D(SUBHEAD("EM"))) D EM
	I $S('$D(SUBHEAD):1,1:$D(SUBHEAD("AUTOPSY"))) D AU
	Q
	;
	;
CY	; Cytology results
	;
	I '$D(^LR(LRDFN,"CY")) D  Q
	. I '$D(SUBHEAD("CYTOPATHOLOGY")) Q
	. D LINE^LR7OSUM4
	. D LN S ^TMP("LRC",$J,GCNT,0)="No Cytology reports available..."
	;
	S LRSS="CY",LRAA(1)="CYTOPATHOLOGY",LRAA=+$O(^LRO(68,"B",LRAA(1),0)) S:'LRAA LRAA=$$FIND(LRSS)
	D GET
	Q
	;
	;
SPA	; Surgical Pathology results
	;
	I '$D(^LR(LRDFN,"SP")) D  Q
	. I '$D(SUBHEAD("SURGICAL PATHOLOGY")) Q
	. D LINE^LR7OSUM4
	. D LN S ^TMP("LRC",$J,GCNT,0)="No Surgical Pathology reports available..."
	;
	S LRSS="SP",LRAA(1)="SURGICAL PATHOLOGY",LRAA=+$O(^LRO(68,"B",LRAA(1),0)) S:'LRAA LRAA=$$FIND(LRSS)
	D GET
	Q
	;
	;
EM	; Electron Microscopy results
	;
	I '$D(^LR(LRDFN,"EM")) D  Q
	. I '$D(SUBHEAD("EM")) Q
	. D LINE^LR7OSUM4
	. D LN S ^TMP("LRC",$J,GCNT,0)="No EM reports available..."
	;
	S LRSS="EM",LRAA(1)="ELECTRON MICROSCOPY",LRAA=+$O(^LRO(68,"B","EM",0)) S:'LRAA LRAA=$$FIND(LRSS)
	D GET
	Q
	;
	;
AU	; Autopsy results
	;
	I '$D(^LR(LRDFN,"AU")) D  Q
	. I '$D(SUBHEAD("AUTOPSY")) Q
	. D LINE^LR7OSUM4
	. D LN S ^TMP("LRC",$J,GCNT,0)="No Autopsy report available..."
	;
	D EN^LR7OSAP2(LRDFN)
	Q
	;
	;
FIND(SS)	; Find a valid entry in 68
	;SS=LRSS value to look for
	N I,Y
	S I=0,Y="" F  S I=$O(^LRO(68,I)) Q:I<1  I $P($G(^LRO(68,I,0)),"^",2)=SS S Y=I Q
	Q Y
