#! /usr/bin/env sh

set -o errexit
set -o pipefail
cmd="$@"

function postgres_ready() {
    python3 <<END
import sys
import psycopg2
try:
    dbname = '${POSTGRES_DB}'
    user = '${POSTGRES_USER}'
    password = '${POSTGRES_PASSWORD}'
    host = 'postgres_db'
    port = 5432
    conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host, port=port)
except psycopg2.OperationalError:
    sys.exit(-1)
sys.exit(0)
END
}

until postgres_ready; do
    echo >&2 "Postgres is unavailable - sleeping"
    sleep 1
done

echo >&2 "Postgres is up - continuing..."

echo >&2 "Migrating..."
# alembic init ./app/models/orm/migrations/
# alembic revision --autogenerate
alembic upgrade head

if [[ ${DEBUG} == 'TRUE' ]] || [[ ${DEBUG} == 'True' ]] || [[ ${DEBUG} == '1' ]]; then
    echo >&2 "Starting debug server..."
    exec uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
else
    echo >&2 "Starting production server..."
    exec uvicorn app.main:app --host 0.0.0.0 --port 8000
fi
