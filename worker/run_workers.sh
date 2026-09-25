#!/bin/bash

cleanup_workers() {
  echo "Cleaning up workers..."
  kill -INT -- -1
  wait
  exit
}

trap 'cleanup_workers' SIGTERM
trap 'cleanup_workers' SIGINT

cd /home/worker

git clone \
  https://github.com/official-stockfish/fishtest \
  /home/worker/fishtest

for worker in $(seq 1 $NUM_WORKERS); do
  worker_dir=~/worker$worker
  cp -r fishtest "$worker_dir"
  cd "$worker_dir/worker"
  python3 worker.py -w $WORKER_ARGS && python3 worker.py &
  cd ~
done

wait
