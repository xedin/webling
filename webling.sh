#!/bin/bash

# Path to JAR
JAR=`dirname $0`/target/webling-*-standalone.jar

# Find Java
if [ "$JAVA_HOME" = "" ] ; then
        JAVA="java"
else
        JAVA="$JAVA_HOME/bin/java"
fi

# Set Java options
if [ "$JAVA_OPTIONS" = "" ] ; then
        JAVA_OPTIONS="-Xms64M -Xmx512M"
fi

# Launch the application
$JAVA $JAVA_OPTIONS -cp $JAR com.tinkerpop.webling.WeblingLauncher $1

# Return the program's exit code
exit $?
