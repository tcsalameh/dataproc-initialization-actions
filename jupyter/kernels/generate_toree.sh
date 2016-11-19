#!/bin/bash
#
# Prints a generated JSON spec in to stdout which can be used to configure an
# apache toree Jupyter kernel, based on various version settings like the installed
# spark version.

# As of this time, only spark 1.6.2 is compatible with Toree.

set -e

SPARK_DL='http://d3kbcqa49mib13.cloudfront.net/spark-1.6.2-bin-hadoop2.6.tgz'
TOREE_SPARK_HOME='/usr/lib/spark'

# This will let us exit with error code if not found.
PY4J_ZIP=$(ls /usr/lib/spark/python/lib/py4j-*.zip)

# In case there are multiple py4j versions or unversioned symlinks to the
# versioned file, just choose the first one to use for jupyter.
PY4J_ZIP=$(echo ${PY4J_ZIP} | cut -d ' ' -f 1)
echo "Found PY4J_ZIP: '${PY4J_ZIP}'" >&2

PACKAGES_ARG='--packages com.databricks:spark-csv_2.10:1.3.0'

cat << EOF
{
 "argv": [
    "/dataproc-initialization-actions/jupyter/kernels/apache_toree_scala/bin/run.sh",
		"--profile",
		"{connection_file"],
 "display_name": "Apache Toree - Scala",
 "language": "scala",
 "env": {
    "PYTHON_EXEC": "python",
		"SPARK_HOME": "/usr/lib/spark",
    "__TOREE_OPTS__": "",
		"__TOREE_SPARK_OPTS__": "",
		"DEFAULT_INTERPRETER": "Scala",
		"PYTHONPATH": "/usr/lib/spark/python/:${PY4J_ZIP}"
 }
}
EOF
