all:
	make compile
	make clean
	make test
compile:
	fpc array_and_numbers.pas	
clean:
	rm -f output.txt
test:
	./tests.sh
