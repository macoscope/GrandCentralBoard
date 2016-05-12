#!/bin/sh

function run_tests
{
	# read https://github.com/supermarin/xcpretty#usage to get more details about the way xcpretty is used
  	xcodebuild test -workspace GrandCentralBoard.xcworkspace -scheme GrandCentralBoard -sdk appletvsimulator9.2 -configuration 'Debug' ONLY_ACTIVE_ARCH=NO | xcpretty -c -f `xcpretty-travis-formatter`; exit ${PIPESTATUS[0]}
}

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]] || [[ "$TRAVIS_BRANCH" == "mvp" ]]; then
	run_tests || exit $?
	exit 0
fi
