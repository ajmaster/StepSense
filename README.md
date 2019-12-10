# StepSense
iOS App for step pressure sensing and associated heat map

This iOS app interacts with the RaspBerry Pi Zero via Firebase Cloud DB to read/write pressure sensing data gathered through Velostat pressure conductivity sensor sheets through ADS1115 ADC. This data is then rendered into a "heatmap" of pressure data through color gradients and also indicates the number of steps taken.

Motivation: As  emerging  technologies  continue  to  disrupt  ourdaily  lives,  today’s  society  is  challenged  with  having  to  choosebetween  a  wide  variety  of  IoT  devices  that  can  fundamentallychange  the  way  they  live.  With  the  growing  number  use  casesthat  wireless  devices  can  solve,  from  the  outside  world,  to  ouremployment, and into our homes, we need efficient mechanismsto  let  the  wireless  devices  communicate  securely.  One  of  themore  sensitive  industries  where  IoT  has  seen  vast  increases  inuse  is  healthcare.  The  healthcare  industry  has  been  quick  toadopt connected medical devices as they can help providers offera  better  standard  of  care  while  also  improving  efficiency  andlowering  operational  costs.  One  of  the  biggest  applications  forIoT  in  the  healthcare  sphere  is  wearable  devices  that  allow  forremote  monitoring  of  various  vital  signs  and  health  statisticsevidenced   by   the   use   of   devices   such   as   the   Apple   Watch,Fitbit,  and  Garmin  smartwatches  among  others.  However,  dueto  the  fact  that  these  wearables  are  worn  on  the  wrist,  theycan  vary  wildly  in  accuracy.  [1]  In  this  project,  we  aim  toestablish a more discrete wearable device in the form of Velostatpressure  sensor  sheets  that  can  be  attached  to  a  user’s  shoeinsert  and  interacts  with  an  associated  iOS  app  to  provide  adetailed  mapping  of  foot  pressure  and  pedometer  measurementdata communicated through WiFi/Bluetooth protocols configuredthrough  a  Raspberry  Pi  Zero.

Setup:

Make sure to have Cocoapods installed, then run the following command to install dependencies:
- pods init

- configure the info.plist file with your own configuration of Firebase DB
https://firebase.google.com/docs/ios/setup

Open the xcworkspace file and run the app