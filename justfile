set windows-shell := ["pwsh.exe", "-c"]
set dotenv-load

[windows]
flutter +rest:
    flutter {{rest}} --dart-define=SUPABASE_URL="$env:SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$env:SUPABASE_ANON_KEY"

[linux]
flutter +rest:
    flutter {{rest}} --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

run +rest:
    just flutter run {{rest}}
