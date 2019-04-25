#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#	     									    	  #
# 	THIS SCRIPT IS NOT AN OFFICIAL PRODUCT OF JAMF SOFTWARE				  #
# 	AS SUCH IT IS PROVIDED WITHOUT WARRANTY OR SUPPORT	    			  #
#											  #
#	BY USING THIS SCRIPT, YOU AGREE THAT JAMF SOFTWARE IS UNDER NO OBLIGATION 	  #
#       TO SUPPORT, DEBUG, OR OTHERWISE	MAINTAIN THIS SCRIPT				  #
#	     									   	  #
#	THIS SCRIPT IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 		  #
#	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 	  #
#       AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 		  #
#	JAMF SOFTWARE, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 	  #
#	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT   #
#	OF SUBSTITUTE GOODS OR SERVICES;LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 	  #
#	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 	  #
#	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING   #
#	IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 		  #
#	POSSIBILITY OF SUCH DAMAGE.							  #
#	     									   	  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#	     									    	  #
#	This script will remove all versions of Jamf Connect and NoMAD/NoMAD Login	  #					
#	     									    	  #							   
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#	     									    	  #
#	Last Modified - March 28, 2019	       					   	  #
#	     									    	  #	 									   
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

                                 
# Find if there's a console user or not. Blank return if not.
consoleuser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# get the UID for the user

uid=`/usr/bin/id -u "$consoleuser"`

###########################################
######	Checking and Removing NoMAD  ######
###########################################

#Creates variables for NoMAD Locations
echo "Checking for NoMAD"
nloc="/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist"
napp="/Applications/NoMAD.app"
nplist="/Library/Managed Preferences/com.trusourcelabs.NoMAD.plist"
nshare="/Library/Managed Preferences/menu.nomad.shares.plist"

#Check for NoMAD
if [ -f "$nloc" ] || [ -d "$napp" ] || [ -f "$nplist" ] || [ -f "$nshare" ] ;
then
	echo "NoMAD was found"
	
#Removes NoMAD LaunchAgent if found
	if [ -f "$nloc" ]; 
	then
		/bin/launchctl bootout gui/"$uid" "$nloc"
		/bin/rm "$nloc"
		echo "NoMAD LaunchAgent has been removed from the Computer"
	else
		echo "NoMAD LaunchAgent not found"
	fi
	
#Removes NoMAD Application if found
	if [ -d "$napp" ]; 
	then
		/bin/rm -rf "$napp"
		echo "Removed NoMAD Application"
	else
		echo "NoMAD Application not found"
	fi
#Removes NoMAD .plist if found
	if [ -f "$nplist" ];
	then
		/bin/rm "$nplist"
		echo "Removed the NoMAD .plist"
	else
		echo "NoMAD .plist not found"
	fi
#Removes NoMAD Share .plist if found	
	if [ -f "$nshare" ];
	then
		/bin/rm "$nshare"
		echo "Removed the NoMAD share .plist"
	else
		echo "NoMAD Share .plist not found"
	fi

#NoMAD is not found on the computer
else
	echo "NoMAD not found on the Computer"
fi

###############################################
######	Checking and Removing NoMAD Pro  ######
###############################################

#Creates Variables for NoMAD Pro Locations
echo ""
echo "Checking for NoMAD Pro"
nploc="/Library/LaunchAgents/menu.nomad.NoMADPro.plist"
npapp="/Applications/NoMAD Pro.app"
npplist="/Library/Managed Preferences/menu.nomad.NoMADPro.plist"

#Check for NoMAD Pro
if [ -f "$nploc" ] || [ -d "$npapp" ] || [ -f "$npplist" ];
then
	echo "NoMAD Pro was found"

#Removes NoMAD Pro LaunchAgent if found
	if [ -f "$nploc" ];
	then
		/bin/launchctl bootout gui/"$uid" "$nploc"
		/bin/rm "$nploc"
		echo "NoMAD Pro LaunchAgent has been removed from the Computer"
	else
		echo "NoMAD Pro LaunchAgent not found"
	fi

#Removes NoMAD Pro Application if found
	if [ -d "$npapp" ];
	then
		/bin/rm -rf "$npapp"
		echo "Removed NoMAD Pro Application"
	else
		echo "NoMAD Pro Application not found"
	fi

#Removes NoMAD Pro .plist if found
	if [ -f "$npplist" ];
	then
		/bin/rm "$npplist"
		echo "Removed the NoMAD Pro .plist"
	else
		echo "NoMAD Pro .plist not found"
	fi

#NoMAD Pro is not found on the computer
else
	echo "NoMAD Pro not found on the Computer"
fi

#######################################################
######	Checking and Removing Jamf Connect Sync  ######
#######################################################

#Creates Variables for Jamf Connect Sync Locations
echo ""
echo "Checking for Jamf Connect Sync"
jcsloc="/Library/LaunchAgents/com.jamf.connect.sync.plist"
jcsapp="/Applications/Jamf Connect Sync.app"
jcsplist="/Library/Managed Preferences/com.jamf.connect.sync.plist"

#Check for Jamf Connect Sync
if [ -f "$jcsloc" ] || [ -d "$jcsapp" ] || [ -f "$jcsplist" ];
then
	echo "Jamf Connect Sync was found"

#Removes Jamf Connect Sync LaunchAgent if found
	if [ -f "$jcsloc" ];
	then
		/bin/launchctl bootout gui/"$uid" "$jcsloc"
		/bin/rm "$jcsloc"
		echo "Jamf Connect Sync LaunchAgent has been removed from the Computer"
	else
		echo "Jamf Connect Sync LaunchAgent not found the Computer"
	fi

#Removes Jamf Connect Sync Application if found
	if [ -d "$jcsapp" ];
	then
		/bin/rm -rf "$jcsapp"
		echo "Removed Jamf Connect Sync Application"
	else
		echo "Jamf Connect Sync Application not found the Computer"
	fi

#Removes Jamf Connect Sync .plist if found
	if [ -f "$jcsplist" ];
	then
		/bin/rm "$jcsplist"
		echo "Removed the Jamf Connect Sync .plist"
	else
		echo "Jamf Connect Sync .plist not found the Computer"
	fi

#Jamf Connect Sync is not found on the computer
else
	echo "Jamf Connect Sync not found on the Computer"
fi

#########################################################
######	Checking and Removing Jamf Connect Verify  ######
#########################################################

#Creates Variables for Jamf Connect Verify Locations
echo ""
echo "Checking for Jamf Connect Verify"
jcvloc="/Library/LaunchAgents/com.jamf.connect.verify.plist"
jcvapp="/Applications/Jamf Connect Verify.app"
jcvplist="/Library/Managed Preferences/com.jamf.connect.verify.plist"

#Check for Jamf Connect Verify
if [ -f "$jcvloc" ] || [ -d "$jcvapp" ] || [ -f "$jcvplist" ];
then
	echo "Jamf Connect Verify was found"
	
#Removes Jamf Connect Verify LaunchAgent if found
	if [ -f "$jcvloc" ];
	then
		/bin/launchctl bootout gui/"$uid" "$jcvloc"
		/bin/rm "$jcvloc"
		echo "Jamf Connect Verify LaunchAgent has been removed from the Computer"
	else
		echo "Jamf Connect Verify LaunchAgent not found the Computer"
	fi

#Removes Jamf Connect Verify Application if found
	if [ -d "$jcvapp" ];
	then
		/bin/rm -rf "$jcvapp"
		echo "Removed Jamf Connect Verify Application"
	else
		echo "Jamf Connect Verify Application not found the Computer"
	fi

#Removes Jamf Connect Verify .plist if found
	if [ -f "$jcvplist" ];
	then
		/bin/rm "$jcvplist"
		echo "Removed the Jamf Connect Verify .plist"
	else
		echo "Jamf Connect Verify .plist not found the Computer"
	fi

#Jamf Connect Verify is not found on the computer
else
	echo "Jamf Connect Verify not found on the Computer"
fi


########################################################
######	Checking and Removing Jamf Connect Login  ######
########################################################

#Creates Variables for Jamf Connect Login Locations
echo ""
echo "Checking for Jamf Connect Login"
jclloc="/Library/Security/SecurityAgentPlugins/JamfConnectLogin.bundle"
jcloloc="/Library/Security/SecurityAgentPlugins/NoMADLoginOkta.bundle"
jclplist="/Library/Managed Preferences/com.jamf.connect.login.plist"

#Check for Jamf Connect Login and changes Login Window back to Apples
if [ -e "$jclloc" ] || [ -e "$jcloloc" ] || [ -f "$jclplist" ];
then
	echo "Jamf Connect Login was found"
	/usr/local/bin/authchanger -reset

#Removes Jamf Connect Login bundle
	if [ -e "$jclloc" ];
	then
		/bin/rm -rf "$jclloc"
		echo "Jamf Connect Login Application has been removed from the Computer"
	else
		echo "Jamf Connect Login Application not found the Computer"
	fi

#Removes Jamf Connect Login Okta bundle
	if [ -e "$jcloloc" ];
	then
		/bin/rm -rf "$jcloloc"
		echo "Jamf Connect Login Okta Bundle has been removed from the Computer"
	else
		echo "Jamf Connect Login Okta Bundle not found the Computer"
	fi
	
#Removes Jamf Connect Login .plist
	if [ -f "$jclplist" ];
	then
		/bin/rm "$jclplist"
		echo "Jamf Connect Login .plist has been removed from the Computer"
	else
		echo "Jamf Connect Login .plist not found the Computer"
	fi

#Jamf Connect Login is not found on the computer
else
	echo "Jamf Connect Login not found on the Computer"
fi

#################################################
######	Checking and Removing NoMAD Login  ######
#################################################

#Creates Variables for NoMAD Login Locations
echo ""
echo "Checking for NoMAD Login"
nlloc="/Library/Security/SecurityAgentPlugins/NoMADLoginAD.bundle"
nlplist="/Library/Managed Preferences/menu.nomad.login.ad.plist"

#Check for NoMAD Login and changes Login Window back to Apples
if [ -e "$nlloc" ] || [ -f "$nlplist" ];
then
	echo "NoMAD Login was found"
	/usr/local/bin/authchanger -reset

#Removes NoMAD Login and .plist if found and resets the loginwindow to Apples
	if [ -e "$nlloc" ];
	then
		/bin/rm -rf "$nlloc"
		echo "NoMAD Login Application has been removed from the Computer"
	else
		echo "NoMAD Login Application not found on the Computer"
	fi
	
#Removes NoMAD Login .plist
	if [ -f "$nlplist" ];
	then
		/bin/rm "$nlplist"
		echo "NoMAD Login .plist has been removed from the Computer"
	else
		echo "NoMAD Login .plist not found the Computer"
	fi

#NoMAD Login is not found on the computer
else
	echo "NoMAD Login not found on the Computer"
fi

#####################################
######	Kill the Login Window  ######
#####################################
if [ -e "$jclloc" ] || [ -e "$jcloloc" ] || [ -f "$jclplist" ] || [ -e "$nlloc" ] || [ -f "$nlplist" ] ;
then
	echo "Resetting the Login Window"
	killall loginwindow
else
	echo "We do not need to reset Login Window" 
fi
