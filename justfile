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
    dart_define generate --SUPABASE_URL $env:SUPABASE_URL --SUPABASE_ANON_KEY $env:SUPABASE_ANON_KEY --GOOGLE_OAUTH_WEB_CLIENT_ID $env:GOOGLE_AUTH_WEB_CLIENT_ID --GOOGLE_OAUTH_IOS_CLIENT_ID $env:GOOGLE_OAUTH_IOS_CLIENT_ID --FLAVOR=development
