#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects
# use sh ./flutterfire-config.sh dev
# use sh ./flutterfire-config.sh stag
# use sh ./flutterfire-config.sh prod

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'stag', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project=fms-outcome \
      --out=lib/firebase_options_dev.dart \
      --ios-bundle-id=asia.outcome.fms \
      --ios-out=ios/flavors/dev/GoogleService-Info.plist \
      --android-package-name=asia.outcome.fms.demo \
      --android-out=android/app/src/dev/google-services.json
    ;;
  stag)
    flutterfire config \
      --project=fms-outcome \
      --out=lib/firebase_options_stg.dart \
      --ios-bundle-id=asia.outcome.fms \
      --ios-out=ios/flavors/stag/GoogleService-Info.plist \
      --android-package-name=asia.outcome.fms.staging \
      --android-out=android/app/src/stag/google-services.json
    ;;
  prod)
    flutterfire config \
      --project=fms-outcome \
      --out=lib/firebase_options_prod.dart \
      --ios-bundle-id=vn.imark.fms \
      --ios-out=ios/flavors/prod/GoogleService-Info.plist \
      --android-package-name=asia.outcome.fms \
      --android-out=android/app/src/prod/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'stag', or 'prod'."
    exit 1
    ;;
esac