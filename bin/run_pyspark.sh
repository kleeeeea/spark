#!/usr/bin/env bash


if [ -z "${SPARK_HOME}" ]; then
  source "$(dirname "$0")"/find-spark-home
fi

source "${SPARK_HOME}"/bin/load-spark-env.sh
export _SPARK_CMD_USAGE="Usage: ./bin/pyspark [options]"

export PYSPARK_PYTHON=/Users/keqianli/anaconda3/bin/python
export PYSPARK_DRIVER_PYTHON=$PYSPARK_PYTHON

if [ -n "${JAVA_HOME}" ]; then
  RUNNER="${JAVA_HOME}/bin/java"$
else
  if [ "$(command -v java)" ]; then
    RUNNER="java"
  else
    echo -n "JAVA_HOME is not set. Would you like to install JDK 17 and set JAVA_HOME? (Y/N) " >&2

    read -r input

    if [[ "${input,,}" == "y" ]]; then
        TEMP_DIR=$(mktemp -d)
        $PYSPARK_DRIVER_PYTHON -m pip install --target="$TEMP_DIR" install-jdk
        export JAVA_HOME=$(PYTHONPATH="$TEMP_DIR" $PYSPARK_DRIVER_PYTHON -c 'import jdk; print(jdk.install("17"))')
        RUNNER="${JAVA_HOME}/bin/java"
        echo "JDK was installed to the path \"$JAVA_HOME\""
        echo "You can avoid needing to re-install JDK by setting your JAVA_HOME environment variable to \"$JAVA_HOME\""
    else
        echo "JDK installation skipped. You can manually install JDK (17 or later) and set JAVA_HOME in your environment."
        exit 1
    fi
  fi
fi
export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH"
#exec "${SPARK_HOME}"/bin/spark-submit pyspark-shell-main --name "PySparkShell" "$@"
# pyspark-shell-main
# --conf spark.driver.extraJavaOptions=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005

    exec "${SPARK_HOME}"/bin/spark-submit /Users/keqianli/klee_code/spark_code/Pyspark/_data/hello.py  --name "PySparkShell" "$@"   -c spark.driver.bindAddress=localhost  --master local
    