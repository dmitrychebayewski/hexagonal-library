#!/bin/bash
flyway baseline -baselineVersion="0.0" -locations=filesystem:/sql
flyway migrate -locations=filesystem:/sql

