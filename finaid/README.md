finaid
======

edload2.au3
-----------

edload2.au3 is the second generation program build to compress and move files into Banner.

The workflow is as follows:

1. EDConnect creates its files.

2. edload2.au3 runs. It firsts checks for correction files, compiles them into TAP files, uploads the compiled files to Banner via WinSCP, and moves the source files into a "processed" folder.

3. edload2.au3 follows suit for other EDConnect files.  It compiles them into TAP files, uploads the compiled version, and then moves the source file into the same "processed" folder.

4. edload2.au3 then terminates itself.

With the files uploaded to Banner, you can then use the INB interface to load the TAP files.

edload2.au3 requires Windows read and write access to the EDConnect files, either locally or through a mapped directory.

corrdl.au3
----------

corrdl.au3 and corrdl.ini are files for moving corr??in.dat files from the Batch server to wherever EDConnect wants them.