#!/bin/bash
. `dirname $0`/setenv.sh

"${JAVACMD}" -cp $JSHOMEDIR:$UI_JARS:$GS_JARS -Djava.security.policy=${POLICY} com.gigaspaces.admin.ui.lookupbrowser.Browser
