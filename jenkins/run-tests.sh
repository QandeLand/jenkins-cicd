#!/bin/sh
pip install -r /app/requirements.txt --quiet
pytest /app/tests/ -v
