ISI94UPD ;  Updates from patch 94 post install
 ;;;;;;Build 8
 Q
 ;
POS ;
 D REINDEX^MAGIPS93
 S X=$$UPD94()
 ;
 ;--- Update field #6 in IMAGE FILE FORMATS file (#2005.021)
 ;--- Update field #42 (TYPE INDEX) in MAG DESCRIPTIVE CATEGORIES file (#2005.81)
 ; to 77 if field #1 (CLASS) equals "ADMIN"
UPD94() ; Misc Updates
 ; Add values for the new field in IMAGE FILE FORMATS File
 ; The new field is $p 7 of the 0 node.
 ; named : FORMAT IS SUPPORTED
 N I
 S I=0
 F  S I=$O(^MAG(2005.021,I)) Q:'I  D
 . S $P(^MAG(2005.021,I,0),"^",7)=$S($P(^MAG(2005.021,I,0),"^",1)="DOC":"0",1:"1")
 . Q
 ; Change field #42 in file (#2005.81) to 77 if 2nd piece of 0 node is "ADMIN"
 ; and piece 3 of 2 node is 45 and .01 field equals "MISCELLANEOUS"
 ;
 S I=""
 F  S I=$O(^MAG(2005.81,"B","MISCELLANEOUS",I)) Q:I=""  D
 . I $P(^MAG(2005.81,I,0),"^",2)="ADMIN" D
 . . S:$P(^MAG(2005.81,I,2),"^",3)=45 $P(^MAG(2005.81,I,2),"^",3)=77
 . Q
 ;
 ; Upref file, and set the EKG Node
 S I=0 F  S I=$O(^MAG(2006.18,I)) Q:'I  S ^MAG(2006.18,I,"EKG")="2^1^1^600^400^0"
 Q 0
 ;
