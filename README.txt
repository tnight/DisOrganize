----------------------------------------------------------------------------
                    iTunes Library DisOrganize Utility
                                README file

                                Version 1.0.1
----------------------------------------------------------------------------
                     (c)Copyright, Terry Nightingale 2015-2016
----------------------------------------------------------------------------
This file contains the latest information about DisOrganize. Be sure to
read it before using DisOrganize.
----------------------------------------------------------------------------
Contents
----
1. About this software
2. Usage
3. License
4. Contact information


1. About this software
----
This software re-organizes iTunes media files to match the path and name 
specified in an iTunes library file in XML format. An example of when to
use this software is when iTunes' attempt to "organize library" goes
horribly wrong and you have to undo the organization.


2. Usage
----
DisOrganize.pl iTunes\ Library.xml 1>DisOrganize.sh 2>DisOrganize.log

As input, pass the name of an iTunes library file in XML format. On STDOUT, 
the output will be a Unix shell script containing all of the file move
commands needed to restore your iTunes media files to the state recorded
in the iTunes library file. On STDERR, the output will be a log of
the software's activity and information relevant for debugging.

The recommended way to run DisOrganize is to redirect STDOUT to a new
file which will become the shell script that does the file moving, and to
redirect STDERR to a log file for easy reference. Once DisOrganize
finishes running, execute the shell script to accomplish the file moves,
and your iTunes media files will match your iTunes library file.


3. License
----
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, version 2 only.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

Visit this URL for more information:
http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html


4. Contact information
----
You can contact the author of this software by email:

Terry Nightingale <tnight@pobox.com>


[END]
