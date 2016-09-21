#!/bin/bash
# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016] EMBL-European Bioinformatics Institute
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


export PERL5LIB=$PWD/bioperl-live:$PWD/modules:$PWD/t/10.pipeconfig
export EHIVE_TEST_PIPELINE_URLS='mysql://travis@127.0.0.1/ pgsql://postgres@127.0.0.1/ sqlite:///'
export TEST_AUTHOR=$USER

echo "Running test suite"
if [ "$COVERALLS" = 'true' ]; then
  PERL5OPT="-MDevel::Cover=+ignore,bioperl,+ignore,/usr/bin/psql,-db,$PWD/cover_db/" prove -rv t
else
  prove -r t
fi

rt=$?
if [ $rt -eq 0 ]; then
  if [ "$COVERALLS" = 'true' ]; then
    echo "Running Devel::Cover coveralls report"
    cover --nosummary -report coveralls
  fi
  exit $?
else
  exit $rt
fi
