ICDDRG17	;ALB/EG - FIX SURGERY HIERARCHY ; 10/9/03 11:41am
	;;18.0;DRG Grouper;**10,31**;Oct 20, 2000;Build 1
	Q:$O(ICDODRG(0))'>0  K ICDJ F ICDJ=0:0 S ICDJ=$O(ICDODRG(ICDJ)) Q:ICDJ'>0  D
	. I ICDDATE<3071001 D F Q
	. E  D FY2008
END	S ICDJ=$O(ICDJ(0)) Q:ICDJ'>0  S ICDJ=ICDJ(ICDJ) K ICDODRG S ICDODRG(ICDJ)="" K ICDJ Q
F	I ICDJ=539 S ICDJ(1)=ICDJ Q
	I ICDJ=540 S ICDJ(2)=ICDJ Q
	I ICDJ=473 S ICDJ(3)=ICDJ Q
	I ICDJ=405 S ICDJ(4)=ICDJ Q
	I ICDJ=401 S ICDJ(5)=ICDJ Q
	I ICDJ=402 S ICDJ(6)=ICDJ Q
	I ICDJ=403 S ICDJ(7)=ICDJ Q
	I ICDJ=404 S ICDJ(8)=ICDJ Q
	I ICDJ=406 S ICDJ(9)=ICDJ Q
	I ICDJ=407 S ICDJ(10)=ICDJ Q
	I ICDJ=408 S ICDJ(11)=ICDJ Q
	I ICDJ=409 S ICDJ(12)=ICDJ Q
	I ICDJ=492 S ICDJ(13)=ICDJ Q
	I ICDJ=410 S ICDJ(14)=ICDJ Q
	I ICDJ=412 S ICDJ(15)=ICDJ Q
	I ICDJ=411 S ICDJ(16)=ICDJ Q
	I ICDJ=413 S ICDJ(17)=ICDJ Q
	I ICDJ=414 S ICDJ(18)=ICDJ Q
	Q
FY2008	;
	I ICDJ=822 S ICDJ(1)=ICDJ Q
	I ICDJ=825 S ICDJ(2)=ICDJ Q
	I ICDJ=828 S ICDJ(3)=ICDJ Q
	I ICDJ=830 S ICDJ(4)=ICDJ
	Q