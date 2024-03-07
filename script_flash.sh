#!/bin/bash

flask shell << EOF
from app import db
db.create_all()
quit()
EOF

flask load-data titanic-min.csv