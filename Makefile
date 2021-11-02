all: compile clean test
compile:
	fpc array_and_numbers.pas	
clean:
	rm -f output_1.txt
	rm -f output_2.txt
	rm -f output_3.txt
	rm -f output_4.txt
	rm -f output_5.txt
	rm -f output_6.txt
	rm -f output_7.txt
	rm -f output_8.txt
	rm -f output_9.txt
test:
	./tests.sh
