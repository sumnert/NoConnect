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
#	If Jamf Connect Login/NoMAD Login is installed it will log out the user		  #				
#	     									    	  #							   
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#	     									    	  #
#	Last Modified - June 10th, 2019	       					   	  #
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
echo "Checking for NoMAD..."
nloc="/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist"
napp="/Applications/NoMAD.app"
nplist="/Library/Managed Preferences/com.trusourcelabs.NoMAD.plist"
nshare="/Library/Managed Preferences/menu.nomad.shares.plist"
nprefplist="/Library/Preferences/com.trusourcelabs.NoMAD.plist"
nprefshare="/Library/Preferences/menu.nomad.shares.plist"
nuserplist="/Users/$consoleuser/Library/Preferences/com.trusourcelabs.NoMAD.plist"
nusershare="/Users/$consoleuser/Library/Preferences/menu.nomad.shares.plist"


#Check for NoMAD
if [ -f "$nloc" ] || [ -d "$napp" ] || [ -f "$nplist" ] || [ -f "$nshare" ] || [ -f "$nprefplist" ] || [ -f "$nprefshare" ] || [ -f "$nuserplist" ] || [ -f "$nusershare" ];
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
#Removes Preferences NoMAD .plist if found	
	if [ -f "$nprefplist" ];
	then
		/bin/rm "$nprefplist"
		echo "Removed the User Preferences NoMAD .plist"
	else
		echo "User Preferences NoMAD .plist not found"
	fi
#Removes Preferences NoMAD Share .plist if found	
	if [ -f "$nprefshare" ];
	then
		/bin/rm "$nprefshare"
		echo "Removed the Preferences NoMAD Share .plist"
	else
		echo "Preferences NoMAD Share .plist not found"
	fi
#Removes User Preferences NoMAD .plist if found	
	if [ -f "$nuserplist" ];
	then
		/bin/rm "$nuserplist"
		echo "Removed the User Preferences NoMAD .plist"
	else
		echo "User Preferences NoMAD .plist not found"
	fi
#Removes User Preferences NoMAD Share if found	
	if [ -f "$nusershare" ];
	then
		/bin/rm "$nusershare"
		echo "Removed the User Preferences NoMAD Share"
	else
		echo "User Preferences NoMAD Share not found"
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
echo "Checking for NoMAD Pro..."
nploc="/Library/LaunchAgents/menu.nomad.NoMADPro.plist"
npapp="/Applications/NoMAD Pro.app"
npplist="/Library/Managed Preferences/menu.nomad.NoMADPro.plist"
nppref="/Library/Preferences/menu.nomad.NoMADPro.plist"
npuser="/Users/$consoleuser/Library/Preferences/menu.nomad.NoMADPro.plist"

#Check for NoMAD Pro
if [ -f "$nploc" ] || [ -d "$npapp" ] || [ -f "$npplist" ] || [ -f "$nppref" ]|| [ -f "$npuser" ];
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
#Removes NoMAD Pro Preferences .plist if found
	if [ -f "$nppref" ];
	then
		/bin/rm "$nppref"
		echo "Removed the NoMAD Pro Preferences .plist"
	else
		echo "NoMAD Pro Preference .plist not found"
	fi
#Removes NoMAD Pro User Preference .plist if found
	if [ -f "$npuser" ];
	then
		/bin/rm "$npuser"
		echo "Removed the NoMAD Pro User Preference .plist"
	else
		echo "NoMAD Pro User Preference .plist not found"
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
echo "Checking for Jamf Connect Sync..."
jcsloc="/Library/LaunchAgents/com.jamf.connect.sync.plist"
jcsapp="/Applications/Jamf Connect Sync.app"
jcsplist="/Library/Managed Preferences/com.jamf.connect.sync.plist"
jcsnomad="/Library/Google/Chrome/NativeMessagingHosts/menu.nomad.nomadpro.json"
jcssync="/Library/Google/Chrome/NativeMessagingHosts/com.jamf.connect.sync.chrome.json"
jcschrome="/Library/Google/Chrome/NativeMessagingHosts/jamfconnect-chrome"
jcsuserpref="/Library/Preferences/com.jamf.connect.sync.plist"
jcspref="/Users/$consoleuser/Library/Preferences/com.jamf.connect.sync.plist"

#Check for Jamf Connect Sync
if [ -f "$jcsloc" ] || [ -d "$jcsapp" ] || [ -f "$jcsplist" ] || [ -f "$jcsnomad" ] || [ -f "$jcssync" ] || [ -f "$jcschrome" ];
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
#Removes Jamf Connect Sync .plist in User Preferences if found
	if [ -f "$jcsuserpref" ];
	then
		/bin/rm "$jcsuserpref"
		echo "Removed the Jamf Connect Sync .plist in User Preferences"
	else
		echo "Jamf Connect Sync .plist in User Preferences not found the Computer"
	fi

#Removes menu.nomad.nomadpro.json if found
	if [ -f "$jcsnomad" ];
	then
		/bin/rm "$jcsnomad"
		echo "Removed Chrome Native Messaging Host - menu.nomad.nomadpro.json"
	else
		echo "Chrome Native Messaging Host - menu.nomad.nomadpro.json not found the Computer"
	fi
#Removes com.jamf.connect.sync.chrome.json if found
	if [ -f "$jcssync" ];
	then
		/bin/rm "$jcssync"
		echo "Removed Chrome Native Messaging Host - com.jamf.connect.sync.chrome.json"
	else
		echo "Chrome Native Messaging Host - com.jamf.connect.sync.chrome.json not found the Computer"
	fi
#Removes jamfconnect-chrome if found
	if [ -f "$jcschrome" ];
	then
		/bin/rm "$jcschrome"
		echo "Removed Chrome Native Messaging Host - jamfconnect-chrome"
	else
		echo "Chrome Native Messaging Host - jamfconnect-chrome"
	fi	
#Removes Jamf Connect Sync Preferences .plist if found
	if [ -f "$jcspref" ];
	then
		/bin/rm "$jcspref"
		echo "Removed the Jamf Connect Sync Preferences .plist"
	else
		echo "Jamf Connect Sync Preference .plist not found"
	fi
#Removes Jamf Connect Sync User Preference .plist if found
	if [ -f "$jcsuserpref" ];
	then
		/bin/rm "$jcsuserpref"
		echo "Removed the Jamf Connect Sync User Preference .plist"
	else
		echo "Jamf Connect Sync User Preference .plist not found"
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
echo "Checking for Jamf Connect Verify..."
jcvloc="/Library/LaunchAgents/com.jamf.connect.verify.plist"
jcvapp="/Applications/Jamf Connect Verify.app"
jcvplist="/Library/Managed Preferences/com.jamf.connect.verify.plist"
jcvuserpref="/Library/Preferences/com.jamf.connect.verify.plist"
jcvpref="/Users/$consoleuser/Library/Preferences/com.jamf.connect.verify.plist"

#Check for Jamf Connect Verify
if [ -f "$jcvloc" ] || [ -d "$jcvapp" ] || [ -f "$jcvplist" ] || [ -f "$jcvuserpref" ] || [ -f "$jcvpref" ];
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
#Removes Jamf Connect Verify Preferences .plist if found
	if [ -f "$jcvpref" ];
	then
		/bin/rm "$jcvpref"
		echo "Removed the Jamf Connect Verify Preferences .plist"
	else
		echo "Jamf Connect Verify Preference .plist not found"
	fi
#Removes Jamf Connect Verify User Preference .plist if found
	if [ -f "$jcvuserpref" ];
	then
		/bin/rm "$jcvuserpref"
		echo "Removed the Jamf Connect Verify User Preference .plist"
	else
		echo "Jamf Connect Verify User Preference .plist not found"
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
echo "Checking for Jamf Connect Login..."
jclloc="/Library/Security/SecurityAgentPlugins/JamfConnectLogin.bundle"
jcloloc="/Library/Security/SecurityAgentPlugins/NoMADLoginOkta.bundle"
jclplist="/Library/Managed Preferences/com.jamf.connect.login.plist"
jcluserpref="/Library/Preferences/com.jamf.connect.login.plist"
jclpref="/Users/$consoleuser/Library/Preferences/com.jamf.connect.login.plist"

#Check for Jamf Connect Login and changes Login Window back to Apples
if [ -e "$jclloc" ] || [ -e "$jcloloc" ] || [ -f "$jclplist" ] || [ -f "$jcluserpref" ] || [ -f "$jclpref" ];
then
	echo "Jamf Connect Login was found"
	/usr/local/bin/authchanger -reset
	lw="true"

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
#Removes Jamf Connect Login Preferences .plist if found
	if [ -f "$jclpref" ];
	then
		/bin/rm "$jclpref"
		echo "Removed the Jamf Connect Login Preferences .plist"
	else
		echo "Jamf Connect Login Preference .plist not found"
	fi
#Removes Jamf Connect Login User Preference .plist if found
	if [ -f "$jcluserpref" ];
	then
		/bin/rm "$jcluserpref"
		echo "Removed the Jamf Connect Login User Preference .plist"
	else
		echo "Jamf Connect Login User Preference .plist not found"
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
echo "Checking for NoMAD Login..."
nlloc="/Library/Security/SecurityAgentPlugins/NoMADLoginAD.bundle"
nlplist="/Library/Managed Preferences/menu.nomad.login.ad.plist"
nluserpref="/Library/Preferences/menu.nomad.login.ad.plist"
nlpref="/Users/$consoleuser/Library/Preferences/menu.nomad.login.ad.plist"

#Check for NoMAD Login and changes Login Window back to Apples
if [ -e "$nlloc" ] || [ -f "$nlplist" ] || [ -f "$nluserpref" ] || [ -f "$nlpref" ];
then
	echo "NoMAD Login was found"
	/usr/local/bin/authchanger -reset
	lw="true"

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
#Removes NoMAD Login Preferences .plist if found
	if [ -f "$nlpref" ];
	then
		/bin/rm "$nlpref"
		echo "Removed the NoMAD Login Preferences .plist"
	else
		echo "NoMAD Login Preference .plist not found"
	fi
#Removes NoMAD Login User Preference .plist if found
	if [ -f "$nluserpref" ];
	then
		/bin/rm "$nluserpref"
		echo "Removed the NoMAD Login User Preference .plist"
	else
		echo "NoMAD Login User Preference .plist not found"
	fi

#NoMAD Login is not found on the computer
else
	echo "NoMAD Login not found on the Computer"
fi

#####################################
######	Kill the Login Window  ######
#####################################

echo ""
#Checking to see if Login Window needs to be reset
if [ "$lw" = true ];
then
	echo "Resetting Login Window"
	killall loginwindow &
else
	echo "Login Window does not need to be reset"
fi
