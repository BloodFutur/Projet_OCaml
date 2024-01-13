.PHONY: all build format edit demo clean

src?=0
dst?=12
graph?=input_nosolution2.txt

all: build

build:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/ftest.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

format:
	ocp-indent --inplace src/*

edit:
	code . -n

test: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe graphs/test/${graph} $(src) $(dst) outfile
	@echo "\n   🥁  RESULT (content of outfile)  🥁\n"
	@cat outfile

demo: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe graphs/exam_schedule/${graph} outfile
	@echo "\n   🥁  RESULT (content of outfile)  🥁\n"
	@cat outfile
	@dot -Tsvg graphs/exam_schedule/flow.txt > graphs/exam_schedule/flow.svg  
	@dot -Tsvg graphs/exam_schedule/original.txt > graphs/exam_schedule/original.svg  
	@dot -Tsvg graphs/exam_schedule/simplified.txt > graphs/exam_schedule/simplified.svg  


clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean
