set shell := ["pwsh.exe", "-c"]
set dotenv-load

flutter +rest:
    @echo $env:SUPABASE_URL
    flutter {{rest}} --dart-define=SUPABASE_URL="$env:SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$env:SUPABASE_ANON_KEY"

run +rest:
    just flutter run {{rest}}
