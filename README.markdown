MoJ Tribunals
=============

A Ruby on Rails application for giving public access to UK Tribunal decisions.

Installation
------------

This application requires 'soffice', a binary that comes with libreoffice.

Installing libreoffice on OSX
-----------------------------

Download and install the standard LibreOffice application. You will need to add the binaries to your path though. Simply add this line to the bottom of your ~/.bash_profile and then re-open your terminal.

> export PATH="$PATH:/Applications/LibreOffice.app/Contents/MacOS"

Installing libreoffice on Ubuntu
--------------------------------

Should be as simple as:

> sudo aptitude install libreoffice

Importing from legacy system
----------------------------

In the import rake namespace are the scripts to scrape the exisiting sites. They will not process the word documents though, and that needs to be done with `rake import:import_word_docs_from_urls`.

Tips
----

* On OS X, having LibreOffice open whilst processing docs will fail the processing