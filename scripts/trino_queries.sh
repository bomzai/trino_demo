pip install -r requirements.txt

# Wait for the data

echo "Waiting for the data"
while [ ! -f "${PYTHON_MONGODB_EOF}" ]; do sleep 1; done
echo "Data ready on MongoDB"


echo "Waiting for data"
while [ ! -f "${PYTHON_MYSQL_EOF}" ]; do sleep 1; done
echo "Data ready on MySQL"

# Wait for trino server to accept connection
sleep 10
echo "Sleep done"

python trino_queries.py 