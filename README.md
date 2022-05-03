# Prometheus

Monster project including: 

0. Core project. Project name - Prometheus.
   Progress ⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜ 70%

Stack: Keychain(Security), LocalAuthentification, RxSwift

0. Chart module. Project name - RetainCycle.
   Made one demo chart
   Progress ⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜50%

1. AR. Project name - Sensor.
   Progress ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%

2. CoreML. Project name - TBA.
   Progress ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%

3. AVFoundation. Project name - ProMotion.
   Made custom videoplayer. Realm wasn't used
   Progress ⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜50%
   
   Notes: 
   Use Realm

4. Photo editor with Metal. Project name - TBA.
   Progress ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%
   
   Notes: 
   Use Realm

5. Widget. Project name - TBA.
   Progress ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%

6. Calendar with notifications. Project name - TBA.
   Progress ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%


To add module:
1. Create proj in the workspace
2. Create SharedConfig, include one from /Features/Config
3. Set that xcconfig as actual in project settings, for both configurations
4. Modify the framework target info.plist
5. Add project name in the plist, that located at FeatureIntermidiate/features.plist
6. Link the target to the main application. Make sure it's embeded - it must be dylib by the way
