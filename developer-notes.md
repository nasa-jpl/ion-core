## Notes to developers:

August 1, 2023

* Each ion-core version is designed to work with the corresponding ION release, e.g., ion-core 4.1.2 uses the ION open-source release 4.1.2 as its sources.
* The mainline of the code is called `current.` Each release will be tagged by the release number in the format <x.y.z>.
* The `nasa-jpl/ion-core` repo is a mirror of an internal repo used by NASA team for development. You may submit pull requests through Github and it will reviewed by ION development team for inclusion into the baseline. If incorporated, your changes will be mirrored back out on the next official release of ion-core.
* Development and testing should be done in separate branches called "update-x.y.z-<contributor-name-and-description>" where x.y.z is the version number of the target ion-core release. If the latest ion-core release is 4.1.2, the next release is either 4.1.3 or 4.2.
* Prior to release, all branches will be merged into a `integration-x.y.z` branch for testing.
* Once integration and testing is complete, we merge `integration-x.y.z` back to current and tag that release point as "x.y.z" 
* If you are using ion-core for a specific project/mission, then you will fork a copy of ion-core (at whatever tag that is appropriate) and host that in your own repo. This repo is meant for open-source version of ion-core. If you have general improvement suggestion, please place your update in a separate update branch and it will be reviewed.
