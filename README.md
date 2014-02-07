Banner Client-Side Scripts
==========================

Ellucian Banner 8.* is marketed as a full-service ERP system, and all that that implies.

Working with it in the various departments at work, I've run into a handful of places where it needs *a little help* to work.  The following collection of [AutoIT Scripts](http://www.autoitscript.com/) are bits of software I've cobbled together where needed.  They are not pretty, they are not architectured, but they work.

Most of these scripts wrap around self-contained executables, such as [WinSCP](http://winscp.net/), which are not included in this repository for reasons of copyright infringement.

finaid
------

These scripts were designed to manage the files produced by EDconnect and make them to the Banner Batch server.

**edload.au3** - The configuration GUI.

**filemover1.au3** - The program that handles the file movement workflow.

**lib.au3** - Functions used in both programs.

finance
-------

Direct Deposit files were partially corrupted when acquired from the INB interface.  This script manages the download of the file through SFTP.

**dirdep.au3** - The GUI that wraps around WinSCP and downloads the direct deposit LIS file.

misc
----

**catall.au3** - The original 16-bit DOS concat.exe program given to us would not work on Win7, so I wrote this to replace it.

To Do
=====

Right now all the scripts are AutoIT scripts, but I would like to add Argos Reports, queries, and whatever comes from integrating Banner with E-Learning.

