#!/bin/sh

for i in commands/*.sh; do
	sh $i || exit 1
done

exit 0
