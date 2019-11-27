#!/bin/bash
for f in *.edt; do
	mv -- "$f" "${f/edt/edt2}"
done
