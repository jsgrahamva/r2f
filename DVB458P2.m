DVB458P2 ;ALB/RBS - POST-INSTALL FOR PATCH DVB*4*58 (CONT.) ; 1/3/07 2:18pm
 ;;4.0;HINQ;**58**;03/25/92;Build 29
 ;
 Q  ;no direct entry
 ;
 ;
 ;NOTE:
 ;The following TEXT lines are a combination of a single 4 digit VBA
 ;rated disabilities code (DX CODE) on one line followed by on the
 ;next sequential line(s), all of the related ICD9 DIAGNOSIS codes
 ;that are to be mapped together.  Each IDC9 code also has a (1/0)
 ;match value that will be filed with it.
 ;
 ;Example:
 ;   ;;5000  = a single (VBA) Rated Disabilities (VA) DX CODE
 ;   ;;003.24~1^376.03~1^730.00~1^... = string of ICD9 DIAGNOSIS CODES
 ;                                      (delimited by (^) up-arrow)
 ;   Each (^) piece contains 2 pieces of data delimited by (~):
 ;     $P(1) = a single ICD9 diagnosis code
 ;     $P(2) = (1/0) match code value
 ;
 ;   Note: If the TEXT line ends with a (;) semi-colon, this means the
 ;         next sequential line is associated with the same DX CODE.
 ;         (No sequential line(s) are carried over to the next
 ;          post-install Routine.)
 ;
TEXT ;;5005
 ;;041.2~0^711.00~0^711.01~0^711.02~0^711.03~0^711.04~0^711.05~0^711.06~0^711.07~0^711.08~0^711.09~0
 ;;5006
 ;;002.0~0^711.00~0^711.01~0^711.02~0^711.03~0^711.04~0^711.05~0^711.06~0^711.07~0^711.08~0^711.09~0
 ;;5007
 ;;094.0~0^713.5~0
 ;;5008
 ;;041.00~0^041.01~0^041.02~0^041.03~0^041.04~0^041.05~0^041.09~0^711.00~0^711.01~0^711.02~0^711.03~0^711.04~0^711.05~0^711.06~0^711.07~0^711.08~0^711.09~0
 ;;5009
 ;;003.23~0^036.82~0^056.71~0^711.11~0^711.12~0^711.13~0^711.14~0^711.15~0^711.16~0^711.17~0^711.18~0^711.19~0^711.31~0^711.32~0^711.33~0^711.34~0^711.35~0^711.36~0^711.37~0^711.38~0^711.39~0^711.41~0^;
 ;;711.42~0^711.43~0^711.44~0^711.45~0^711.46~0^711.47~0^711.48~0^711.49~0^711.51~0^711.52~0^711.53~0^711.54~0^711.55~0^711.56~0^711.57~0^711.58~0^711.59~0^711.91~0^711.92~0^711.93~0^711.94~0^711.95~0^;
 ;;711.96~0^711.97~0^711.98~0^711.99~0^716.38~0
 ;;5010
 ;;716.10~0^716.11~0^716.12~0^716.13~0^716.14~0^716.15~0^716.16~0^716.17~0^716.18~0^716.19~1
 ;;5011
 ;;993.3~1
 ;;5012
 ;;160.0~0^170.0~0^170.1~0^170.2~0^170.3~0^170.4~0^170.5~0^170.6~0^170.7~0^170.8~0^170.9~0^198.5~0
 ;;5014
 ;;268.2~1
 ;;5015
 ;;212.0~0^213.0~0^213.1~0^213.2~0^213.3~0^213.4~0^213.5~0^213.6~0^213.7~0^213.8~0^213.9~0^376.42~0^726.91~0
 ;;5016
 ;;731.0~0^731.1~0
 ;;5017
 ;;274.0~1^274.82~1^274.89~1^274.9~1
 ;;5018
 ;;719.30~0^719.31~0^719.32~0^719.33~0^719.34~0^719.35~0^719.36~0^719.37~0^719.38~0^719.39~0
 ;;5019
 ;;095.7~0^098.52~0^726.33~0^726.61~0^726.62~0^726.63~0^726.65~0^727.2~0^727.3~0
 ;;5020
 ;;095.7~0^098.51~0^719.20~0^719.21~0^719.22~0^719.23~0^719.24~0^719.25~0^719.26~0^719.27~0^719.28~0^719.29~0^727.00~0^727.03~0^727.04~0^727.05~0^727.06~0^727.09~0
 ;;5021
 ;;040.81~0^095.6~0^710.4~0^728.0~0^728.81~0^729.1~0
 ;;5022
 ;;091.61~0^376.02~0^730.30~0^730.31~0^730.32~0^730.33~0^730.34~0^730.35~0^730.36~0^730.37~0^730.38~0^730.39~0
 ;;5023
 ;;728.10~0^728.11~0^728.12~0^728.13~0^728.19~0
 ;;5024
 ;;098.51~0^726.11~0^726.61~0^726.62~0^726.63~0^726.64~0^726.65~0^726.72~0^727.03~0^727.04~0^727.05~0^727.06~0^727.09~0
 ;;5025
 ;;729.1~1
 ;;5051
 ;;996.40~0^996.41~0^996.42~0^996.43~0^996.44~0^996.45~0^996.46~0^996.47~0^996.49~0^996.66~0^996.77~0^V43.61~0
 ;;5052
 ;;996.40~0^996.41~0^996.42~0^996.43~0^996.44~0^996.45~0^996.46~0^996.47~0^996.49~0^996.66~0^996.77~0^V43.62~0
 ;;5053
 ;;996.40~0^996.41~0^996.42~0^996.43~0^996.44~0^996.45~0^996.46~0^996.47~0^996.49~0^996.66~0^996.77~0^V43.63~0
 ;;5054
 ;;996.40~0^996.41~0^996.42~0^996.43~0^996.44~0^996.45~0^996.46~0^996.47~0^996.49~0^996.66~0^996.77~0^V43.64~0
 ;;5055
 ;;996.40~0^996.41~0^996.42~0^996.43~0^996.44~0^996.45~0^996.46~0^996.47~0^996.49~0^996.66~0^996.77~0^V43.65~0
 ;;5056
 ;;996.40~0^996.41~0^996.42~0^996.43~0^996.44~0^996.45~0^996.46~0^996.47~0^996.49~0^996.66~0^996.77~0^V43.66~0
 ;;5106
 ;;887.6~1^887.7~1
 ;;5107
 ;;896.2~1^896.3~1
 ;;5108
 ;;887.0~0^887.1~0^887.2~0^887.3~0^887.4~0^887.5~0^896.0~0^896.1~0^V49.63~0^V49.73~0
 ;;5120
 ;;V49.67~0
 ;;5171
 ;;V49.71~0
 ;;5172
 ;;V49.72~0
 ;;5173
 ;;V49.72~0
 ;;5200
 ;;718.51~0
 ;;5201
 ;;719.51~0
 ;;5202
 ;;718.31~0^718.81~0
 ;;5205
 ;;718.52~0
 ;;5206
 ;;718.42~0
 ;;5207
 ;;718.42~0
 ;;5214
 ;;718.53~0
 ;;5215
 ;;718.43~0
 ;;5236
 ;;724.6~1
 ;;5238
 ;;723.0~0^724.00~0^724.01~0^724.02~0^724.09~0
 ;;5239
 ;;738.4~0
 ;;5240
 ;;720.0~0
 ;;5242
 ;;721.0~0^721.2~0^721.3~0^721.6~0^721.7~0^721.90~0
 ;;5243
 ;;722.70~0^722.71~0^722.72~0^722.73~0
 ;;5250
 ;;718.55~1
 ;;5254
 ;;718.85~1
 ;;5255
 ;;733.81~0^733.82~0^905.3~0
 ;;5256
 ;;718.56~0
 ;;5257
 ;;718.36~0^718.86~0
 ;;5258
 ;;718.36~0^836.0~0^836.1~0^836.2~0
 ;;5260
 ;;718.46~0
 ;;5261
 ;;718.46~0
 ;;5263
 ;;736.5~0
 ;;5275
 ;;736.81~0
 ;;5276
 ;;734.~0
 ;;5278
 ;;736.74~0
 ;;5279
 ;;355.6~0
 ;;5280
 ;;735.0~0
 ;;5281
 ;;735.2~0
 ;;5282
 ;;735.3~0^735.4~0
 ;;5324
 ;;551.3~1^552.3~1^553.3~1
 ;;5329
 ;;176.1~1
 ;;6000
 ;;053.22~0^054.44~0^091.50~0^098.41~0^360.11~0^360.12~0^363.21~0^364.00~0^364.01~0^364.02~0^364.03~0^364.04~0^364.10~0^364.11~0^364.23~0^364.24~0^364.3~0
 ;;6001
 ;;054.42~0^054.43~0^090.3~0^264.3~0^370.20~0^370.21~0^370.22~0^370.23~0^370.24~0^370.44~0^370.50~0^370.52~0^370.54~0^370.59~0^370.8~0^370.9~0
 ;;6002
 ;;095.0~0^379.00~0^379.01~0^379.02~0^379.03~0^379.05~0^379.06~0^379.07~0^379.09~0
 ;;6004
 ;;364.21~0
 ;;6006
 ;;115.02~0^115.12~0^115.92~0^130.2~0^362.74~0^363.00~0^363.01~0^363.03~0^363.04~0^363.05~0^363.06~0^363.07~0^363.08~0^363.10~0^363.11~0^363.12~0^363.13~0^363.14~0^363.15~0^363.20~0
 ;;6007
 ;;360.43~0^362.81~0^364.41~0^871.0~0^871.1~0^871.4~0^871.9~0^921.2~0^921.3~0
 ;;6008
 ;;361.00~0^361.01~0^361.02~0^361.03~0^361.04~0^361.05~0^361.06~0^361.07~0^361.2~0^361.81~0^361.89~0^362.41~0^362.42~0^362.43~0
 ;;6010
 ;;017.30~0^017.31~0^017.32~0^017.33~0^017.34~0^017.35~0^017.36~0
 ;;6011
 ;;362.31~0^362.35~0^363.32~0^363.33~0
 ;;6012
 ;;365.20~0^365.21~0^365.22~0^365.23~0^365.24~0^365.41~0^365.43~0^365.44~0^365.52~0^365.59~0^365.61~0^365.62~0^365.63~0^365.64~0^365.65~0^365.81~0^365.83~0
 ;;6013
 ;;365.10~0^365.11~0^365.12~0^365.13~0^365.15~0^365.31~0^365.32~0^365.51~0^365.82~0
 ;;6014
 ;;190.0~0^234.0~0
 ;;6015
 ;;224.0~0^224.1~0^224.2~0^224.3~0^224.4~0^224.5~0^224.6~0^224.7~0^224.9~0^228.03~0
 ;;6016
 ;;379.50~0^379.53~0^379.54~0^379.55~0^379.56~0^386.2~0
 ;;6017
 ;;076.0~0^076.1~0^076.9~0
 ;;6018
 ;;372.10~0^372.11~0^372.12~0^372.13~0^372.14~0^372.15~0
 ;;6019
 ;;374.30~0^374.31~0^374.32~0^374.33~0
 ;;6020
 ;;374.10~0^374.11~0^374.12~0^374.13~0^374.14~0
 ;;6021
 ;;374.00~0^374.01~0^374.02~0^374.03~0^374.04~0
 ;;6022
 ;;374.20~0^374.21~0^374.22~0^374.23~0
 ;;6025
 ;;375.20~0^375.21~0^375.22~0
 ;;6026
 ;;036.81~0^341.0~0^377.30~0^377.32~0^377.33~0^377.34~0^377.39~0^377.41~0
 ;;6027
 ;;366.20~0^366.21~0^366.23~0^366.45~0^366.46~0
 ;;6028
 ;;366.10~0^366.11~0^366.12~0^366.13~0^366.14~0^366.15~0^366.16~0^366.17~0^366.18~0^366.19~0^366.30~0^366.31~0^366.32~0^366.33~0^366.34~0^366.41~0^366.42~0^366.43~0^366.44~0^366.50~0^366.51~0^366.52~0^;
 ;;366.53~0^366.8~0^366.9~0
 ;;6029
 ;;379.31~0
 ;;6030
 ;;367.51~0
 ;;6031
 ;;375.30~0^375.31~0^375.32~0^375.33~0^375.41~0^375.42~0
 ;;6033
 ;;379.32~0^379.33~0^379.34~0
 ;;6034
 ;;372.40~0^372.41~0^372.42~0^372.43~0^372.44~0^372.45~0
 ;;6035
 ;;371.60~0^371.61~0^371.62~0
 ;;6062
 ;;369.04~1
 ;;6063
 ;;369.06~0^V45.78~0
 ;;6066
 ;;369.62~0^V45.78~0
 ;;6067
 ;;369.07~1
 ;;6068
 ;;369.13~1
 ;;6069
 ;;369.17~1^369.62~1
 ;;6070
 ;;369.62~1
 ;;6071
 ;;369.08~1
 ;;6072
 ;;369.14~1
 ;;6073
 ;;369.18~1^369.68~1
 ;;6074
 ;;369.68~1
 ;;6078
 ;;369.75~1
 ;;6080
 ;;368.45~1^368.46~1^368.47~1
 ;;6081
 ;;368.41~1^368.42~1^368.43~1
 ;;6090
 ;;368.2~1
 ;;6091
 ;;372.63~0
 ;;6092
 ;;368.2~1
 ;;6100
 ;;389.00~0^389.01~0^389.02~0^389.03~0^389.04~0^389.08~0^389.15~0^389.10~0^389.12~1^389.14~1^389.16~1^389.18~1^389.2~0^389.7~1^389.8~0^389.9~0
 ;;6200
 ;;382.1~0^382.2~0^382.3~0
 ;;6201
 ;;381.10~0^381.19~0^381.3~0
 ;;6202
 ;;387.0~0^387.1~0^387.2~0^387.8~0^387.9~0^387.0~0
 ;;6204
 ;;078.81~1^386.10~1^386.11~1^386.12~1^386.19~1^780.4~0^078.81~1
 ;;$EXIT
