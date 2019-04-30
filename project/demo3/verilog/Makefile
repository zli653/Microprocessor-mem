all:
	make simple complex
init:
	$(shell PATH=$PATH:/u/s/i/sinclair/courses/cs552/spring2019/handouts/bins)

perf:
	echo "Running perf tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/perf/all.list .
	make run_test
	mv summary.log perf.summary.log


complex_final:
	echo "Running complex_final tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/complex_demofinal/all.list .
	make run_test
	mv summary.log complex_demofinal.summary.log

rand_final:
	echo "Running rand_final tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_final/all.list .
	make run_test
	mv summary.log rand_final.summary.log

rand_ldst:
	echo "Running rand_ldst tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_ldst/all.list .
	make run_test
	mv summary.log rand_ldst.summary.log

rand_idcache:
	echo "Running rand_idcache tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_idcache/all.list .
	make run_test
	mv summary.log rand_idcache.summary.log

rand_icache:
	echo "Running rand_icache tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_icache/all.list .
	make run_test
	mv summary.log rand_icache.summary.log

rand_dcache:
	echo "Running rand_dcache tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_dcache/all.list .
	make run_test
	mv summary.log rand_dcache.summary.log

simple:
	make simple_inst simple_rand rand_ctrl rand_mem

simple_inst:
	echo "Running simple_inst tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/inst_tests/all.list .
	make run_test
	mv summary.log simple_inst.log

simple_rand:
	echo "Running simple_rand tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_simple/all.list .
	make run_test
	mv summary.log simple_rand.log

rand_ctrl:
	echo "Running rand_ctrl tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_ctrl/all.list .
	make run_test
	mv summary.log rand_ctrl.log

rand_mem:
	echo "Running rand_mem tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_mem/all.list .
	make run_test
	mv summary.log rand_mem.log


complex:
	make complex_rand complex_demo1 complex_demo2 complex_demo3

complex_rand:
	echo "Running complex_rand tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/rand_complex/all.list .
	make run_test
	mv summary.log complex_rand.log

complex_demo1:
	echo "Running complex_demo1 tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/complex_demo1/all.list .
	make run_test
	mv summary.log complex_demo1.log

complex_demo2:
	echo "Running complex_demo2 tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/complex_demo2/all.list .
	make run_test
	mv summary.log complex_demo2.log

complex_demo3:
	echo "Running complex_demo3 tests"
	make init
	cp -f ~sinclair/courses/cs552/spring2019/handouts/testprograms/public/complex_demo3/all.list .
	make run_test
	mv summary.log complex_demo3.log

run_test:
	wsrun.pl -list all.list -pipe -align proc_hier_pbench *.v
