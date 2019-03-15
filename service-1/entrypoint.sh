#!/bin/sh

export DJANGO_SETTINGS_MODULE=conf.settings

#python manage.py flush --no-input
python manage.py makemigrations
python manage.py migrate --no-input
python manage.py collectstatic --clear --noinput # clearstatic files
python manage.py collectstatic --noinput  # collect static files

# Prepare log files and start outputting logs to stdout
touch ./logs/gunicorn.log
touch ./logs/gunicorn-access.log
tail -n 0 -f ./logs/gunicorn*.log

# Start Gunicorn processes
echo Starting Gunicorn.
exec gunicorn conf.wsgi:application \
    --name api-web-app \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers 3 \
    --log-level=info \
    --log-file=./logs/gunicorn.log \
    --access-logfile=./logs/gunicorn-access.log \
"$@"


#python manage.py createsuperuser --username=admin --email=tony.salman@hotmail.com
#echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('{{ admin_login }}', '{{ admin_mail }}', '{{ admin_pass }}') " | python manage.py shell
#echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'tony.salman@hotmail.com', 'tony8669') " | python manage.py shell
