set windows-shell := ["pwsh.exe", "-c"]
set dotenv-load

[windows]
flutter +rest:
    flutter {{rest}} --dart-define-from-file=dart_define.json

[linux]
flutter +rest:
    flutter {{rest}} --dart-define-from-file=dart_define.json

run +rest:
    just flutter run {{rest}}

[windows]
dart_define:
    dart_define generate \
        --SUPABASE_URL $env:SUPABASE_URL \
        --SUPABASE_ANON_KEY $env:SUPABASE_ANON_KEY \
        --GOOGLE_OAUTH_WEB_CLIENT_ID $env:GOOGLE_OAUTH_WEB_CLIENT_ID \
        --GOOGLE_OAUTH_IOS_CLIENT_ID $env:GOOGLE_OAUTH_IOS_CLIENT_ID \
        --ANDROID_GOOGLE_API_KEY $env:ANDROID_GOOGLE_API_KEY \
        --GOONG_API_KEY $env:GOONG_API_KEY \
        --MAPTILER_API_KEY $env:MAPTILER_API_KEY \
        --FLAVOR=development
